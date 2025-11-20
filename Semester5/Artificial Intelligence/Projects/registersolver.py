# registersolver.py
# Υλοποίηση αλγορίθμων αναζήτησης για το πρόβλημα του register
from collections import deque
import heapq
import math
import argparse
import time
import sys

# ---- Σταθερές / ρυθμίσεις ----
MAXV = 10**9  # μέγιστη αποδεκτή τιμή register (όπως στο pdf)
DEFAULT_MAX_STATES = 500_000
DEFAULT_MAX_DEPTH = 1000

# ---- Λειτουργίες / πράξεις ----
def op_increase(x):
    """increase: x -> x+1, κόστος 2, προϋπόθεση x < MAXV"""
    if 0 <= x < MAXV:
        return (x + 1, 2, "increase", x)
    return None

def op_decrease(x):
    """decrease: x -> x-1, κόστος 2, προϋπόθεση x > 0"""
    if x > 0:
        return (x - 1, 2, "decrease", x)
    return None

def op_double(x):
    """double: x -> 2*x, κόστος ceil(x/2) + 1, προϋπόθεση x > 0 και 2*x <= MAXV"""
    if x > 0 and 2 * x <= MAXV:
        cost = math.ceil(x / 2) + 1
        return (2 * x, int(cost), "double", x)
    return None

def op_half(x):
    """half: x -> floor(x/2), κόστος ceil(x/4) + 1, προϋπόθεση x > 0"""
    if x > 0:
        nxt = x // 2
        cost = math.ceil(x / 4) + 1
        return (nxt, int(cost), "half", x)
    return None

def op_square(x):
    """square: x -> x*x, κόστος ceil((x^2 - x)/4 + 1), προϋπόθεση x^2 <= MAXV"""
    if x >= 0:
        sq = x * x
        if sq <= MAXV:
            raw = ((sq - x) / 4.0) + 1.0
            cost = max(1, math.ceil(raw))
            return (sq, int(cost), "square", x)
    return None

def op_root(x):
    """root: x -> sqrt(x) (integer), ισχύει μόνο αν x τέλειο τετράγωνο και x > 1,
       κόστος ceil((x - sqrt(x))/4 + 1)"""
    if x > 1:
        r = int(math.isqrt(x))
        if r * r == x:
            raw = ((x - r) / 4.0) + 1.0
            cost = max(1, math.ceil(raw))
            return (r, int(cost), "root", x)
    return None

OPERATIONS = [op_increase, op_decrease, op_double, op_half, op_square, op_root]

def successors(x):
    """Γεννήτρια επιτρεπτών μεταβάσεων: επιστρέφει (new_state, cost, opname, operand)."""
    for op in OPERATIONS:
        r = op(x)
        if r is not None:
            yield r

# ---- Εγγραφή λύσης ----
def write_solution(path, actions):
    """
    actions: λίστα (opname, operand, cost) (όπως θα την επιστρέφει η reconstruct)
    Format:
      N, C
      opname operand cost
    """
    N = len(actions)
    C = sum(cost for (_, _, cost) in actions)
    with open(path, "w", encoding="utf-8") as f:
        f.write(f"{N}, {C}\n")
        for opname, operand, cost in actions:
            f.write(f"{opname} {operand} {cost}\n")

# ---- Ανακατασκευή μονοπατιού ----
def reconstruct(parent, end):
    """
    parent: dict state -> (prev_state, opname, operand, cost)
    επιστρέφει λίστα πράξεων [(opname, operand, cost), ...] από αρχή -> τέλος
    """
    path = []
    cur = end
    while True:
        entry = parent.get(cur)
        if entry is None:
            break
        prev_state, opname, operand, cost = entry
        if prev_state is None:
            break
        path.append((opname, operand, cost))
        cur = prev_state
    return list(reversed(path))

# ---- Αλγόριθμοι αναζήτησης ----

def bfs(start, target, max_states=DEFAULT_MAX_STATES):
    t0 = time.time()
    q = deque([start])
    parent = {start: (None, None, None, 0)}  # root marker
    steps = 0
    while q:
        x = q.popleft()
        steps += 1
        if x == target:
            elapsed = time.time() - t0
            return reconstruct(parent, x), steps, elapsed
        for new, cost, opname, operand in successors(x):
            if new not in parent:
                parent[new] = (x, opname, operand, cost)
                q.append(new)
                if len(parent) > max_states:
                    return None, steps, time.time() - t0
    return None, steps, time.time() - t0

def dfs(start, target, max_depth=DEFAULT_MAX_DEPTH, max_states=DEFAULT_MAX_STATES):
    """
    Iterative DFS με έλεγχο κύκλων στο τρέχον μονοπάτι (visited_on_path)
    και όριο βάθους.
    Επιστρέφει την πρώτη βρέθηκε λύση (όχι βέλτιστη).
    """
    t0 = time.time()
    parent = {start: (None, None, None, 0)}
    stack = [(start, iter(successors(start)), 0)]
    visited_on_path = {start}
    steps = 0
    while stack:
        node, children_iter, depth = stack[-1]
        steps += 1
        if node == target:
            return reconstruct(parent, node), steps, time.time() - t0
        try:
            new, cost, opname, operand = next(children_iter)
            if new in visited_on_path:
                continue
            if depth + 1 > max_depth:
                continue
            parent[new] = (node, opname, operand, cost)
            stack.append((new, iter(successors(new)), depth + 1))
            visited_on_path.add(new)
            if len(parent) > max_states:
                return None, steps, time.time() - t0
        except StopIteration:
            # backtrack
            stack.pop()
            visited_on_path.discard(node)
    return None, steps, time.time() - t0

def best_first(start, target, max_states=DEFAULT_MAX_STATES):
    """
    Greedy best-first με h(x) = |x - target|. Δεν είναι εγγυημένα βέλτιστη.
    Επιστρέφει την πρώτη λύση που βρει.
    """
    t0 = time.time()
    def h(x): return abs(x - target)
    pq = []
    heapq.heappush(pq, (h(start), 0, start))
    parent = {start: (None, None, None, 0)}
    seen = {start}
    steps = 0
    while pq:
        _, _, x = heapq.heappop(pq)
        steps += 1
        if x == target:
            return reconstruct(parent, x), steps, time.time() - t0
        for new, cost, opname, operand in successors(x):
            if new not in seen:
                seen.add(new)
                parent[new] = (x, opname, operand, cost)
                heapq.heappush(pq, (h(new), steps, new))
                if len(parent) > max_states:
                    return None, steps, time.time() - t0
    return None, steps, time.time() - t0

def astar_dijkstra(start, target, max_states=DEFAULT_MAX_STATES):
    """
    A* με h(x) = 0 -> ισοδυναμεί με Dijkstra (βελτιστοτητα ως προς κόστος).
    Χρησιμοποιεί gcost dict για να αποφεύγει ενημερώσεις με χειρότερα κόστη.
    Επιστρέφει βέλτιστη λύση ως προς το συνολικό κόστος (αν τελειώσει).
    """
    t0 = time.time()
    def h(x): return 0
    pq = []
    # store (f, g, state)
    heapq.heappush(pq, (h(start), 0, start))
    parent = {start: (None, None, None, 0)}
    gcost = {start: 0}
    steps = 0
    while pq:
        f, g, x = heapq.heappop(pq)
        # obsolete entry check
        if gcost.get(x, float('inf')) < g:
            continue
        steps += 1
        if x == target:
            return reconstruct(parent, x), steps, time.time() - t0
        for new, cost, opname, operand in successors(x):
            ng = g + cost
            if ng < gcost.get(new, float('inf')):
                gcost[new] = ng
                parent[new] = (x, opname, operand, cost)
                heapq.heappush(pq, (ng + h(new), ng, new))
                if len(parent) > max_states:
                    return None, steps, time.time() - t0
    return None, steps, time.time() - t0

# ---- Dispatcher / main ----
def solve(method, start, target, outfile,
          max_states=DEFAULT_MAX_STATES, max_depth=DEFAULT_MAX_DEPTH, verbose=True):
    start = int(start); target = int(target)
    if not (0 <= start <= MAXV and 0 <= target <= MAXV):
        raise ValueError("start/target out of range (0 <= v <= 10^9)")
    if verbose:
        print(f"Method={method}, start={start}, target={target}, max_states={max_states}, max_depth={max_depth}")
    t0 = time.time()
    if method == "breadth":
        sol, steps, elapsed = bfs(start, target, max_states=max_states)
    elif method == "depth":
        sol, steps, elapsed = dfs(start, target, max_depth=max_depth, max_states=max_states)
    elif method == "best":
        sol, steps, elapsed = best_first(start, target, max_states=max_states)
    elif method == "astar":
        sol, steps, elapsed = astar_dijkstra(start, target, max_states=max_states)
    else:
        raise ValueError("unknown method")
    total_time = time.time() - t0
    if sol is None:
        print(f"No solution found within resource limits. Search steps: {steps}, time: {elapsed:.3f}s, total_time: {total_time:.3f}s")
        return False
    # sol is list of (opname, operand, cost)
    write_solution(outfile, sol)
    total_cost = sum(cost for (_, _, cost) in sol)
    if verbose:
        print(f"Found solution: instructions={len(sol)}, total_cost={total_cost}, search_steps={steps}, search_time={elapsed:.3f}s, total_time={total_time:.3f}s")
        print(f"Wrote solution to: {outfile}")
    return True

def parse_args():
    p = argparse.ArgumentParser(description="Register problem solver")
    p.add_argument("method", choices=["breadth", "depth", "best", "astar"], help="search method")
    p.add_argument("start", type=int, help="start value (integer)")
    p.add_argument("target", type=int, help="target value (integer)")
    p.add_argument("outfile", help="path for solution output")
    p.add_argument("--max-states", type=int, default=DEFAULT_MAX_STATES, help="limit visited states")
    p.add_argument("--max-depth", type=int, default=DEFAULT_MAX_DEPTH, help="limit depth (for DFS)")
    p.add_argument("--quiet", action="store_true", help="no verbose printing")
    return p.parse_args()

if __name__ == "__main__":
    args = parse_args()
    try:
        ok = solve(args.method, args.start, args.target, args.outfile,
                   max_states=args.max_states, max_depth=args.max_depth,
                   verbose=(not args.quiet))
        if not ok:
            sys.exit(2)
    except Exception as e:
        print("Error:", e)
        sys.exit(1)
