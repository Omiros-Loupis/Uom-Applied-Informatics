import sys
import math
import heapq
import time
from collections import deque

# Ergasia 1 - To provlima tou kataxwriti
# Onoma: OMIROS LOUPIS
# AM: iis23088

class RegisterProblem:
    def __init__(self, start, target, time_limit=60):
        self.start = start
        self.target = target
        self.time_limit = time_limit
        self.start_time = 0
        self.MAX_VAL = 10**9

    # Synartisi pou briskei tis epomenes dynates katastaseis
    def get_moves(self, u):
        moves = []
        
        # 1. Increase (Auksisi kata 1) -> Cost: 2
        if u < self.MAX_VAL:
            moves.append(("increase", u + 1, 2))
        
        # 2. Decrease (Meiwsi kata 1) -> Cost: 2
        if u > 0:
            moves.append(("decrease", u - 1, 2))
            
        # 3. Double (Diplasiasmos) -> Cost: [x/2] + 1
        if u > 0 and (2 * u) <= self.MAX_VAL:
            cost = (u // 2) + 1
            moves.append(("double", 2 * u, cost))
            
        # 4. Half (Ypodiplasiasmos) -> Cost: [x/4] + 1
        if u > 0:
            cost = (u // 4) + 1
            moves.append(("half", u // 2, cost))
            
        # 5. Square (Tetragwno) -> Cost: (x^2-x)/4 + 1
        if u > 1:
            square_val = u ** 2
            if square_val <= self.MAX_VAL:
                cost = ((square_val - u) // 4) + 1
                moves.append(("square", square_val, cost))
        
        # 6. Root (Tetragwniki Riza) -> Cost: |x-sqrt(x)|/4 + 1
        if u > 1:
            root = math.isqrt(u)
            # Elegxos an einai teleio tetragwno
            if root * root == u:
                cost = (abs(u - root) // 4) + 1
                moves.append(("root", root, cost))

        return moves

    # Heuristic function (EureΣυγκρίνετε τους χρόνους επίλυσης και το πλήθος των βημάτων σε κάθε λύση.)
    def h(self, n):
        # H pio apodotiki praksi einai to square, opote diairoume tin apostasi me 4
        # gia na eimaste sigouroi oti einai admissible (paradekti).
        return abs(self.target - n) / 4.0

    # Elegxos an perase o xronos
    def check_time(self):
        if time.time() - self.start_time > self.time_limit:
            return True
        return False

    # --- Algorithmoi Anazitisis ---

    def run_bfs(self):
        # H oura krataei (trexon_noumero, monopati)
        q = deque([(self.start, [])])
        visited = {self.start}
        
        while q:
            if self.check_time(): return None, 0
            
            curr, path = q.popleft()

            if curr == self.target:
                total_cost = sum(step[2] for step in path)
                return path, total_cost

            for op, next_val, cost in self.get_moves(curr):
                if next_val not in visited:
                    visited.add(next_val)
                    # Apothikeuoume tin praksi, ton arithmo PRIN tin praksi, kai to kostos
                    new_step = (op, curr, cost)
                    q.append((next_val, path + [new_step]))
        return None, 0

    def run_dfs(self):
        # Stack gia DFS
        # Xrisimopoiw global visited gia na apofygw tous kyklous kai to stack overflow
        stack = [(self.start, [], 0)]
        visited = {self.start} 
        
        while stack:
            if self.check_time(): return None, 0

            curr, path, total_cost = stack.pop()

            if curr == self.target:
                return path, total_cost

            for op, next_val, cost in self.get_moves(curr):
                if next_val not in visited:
                    visited.add(next_val)
                    new_step = (op, curr, cost)
                    stack.append((next_val, path + [new_step], total_cost + cost))
        return None, 0

    def run_best_first(self):
        # Priority Queue me bash to heuristic
        pq = []
        heapq.heappush(pq, (self.h(self.start), self.start, [], 0))
        visited = {self.start}

        while pq:
            if self.check_time(): return None, 0

            _, curr, path, total_cost = heapq.heappop(pq)

            if curr == self.target:
                return path, total_cost

            for op, next_val, cost in self.get_moves(curr):
                if next_val not in visited:
                    visited.add(next_val)
                    new_step = (op, curr, cost)
                    # Sortarei mono me basi to heuristic tou epomenou
                    heapq.heappush(pq, (self.h(next_val), next_val, path + [new_step], total_cost + cost))
        return None, 0

    def run_astar(self):
        # Priority Queue: (f_score, current_val, path, g_cost)
        pq = []
        start_h = self.h(self.start)
        heapq.heappush(pq, (start_h, self.start, [], 0))
        
        # Dictionary gia ta g_scores (velstisto kostos mexri twra)
        g_scores = {self.start: 0}

        while pq:
            if self.check_time(): return None, 0

            _, curr, path, g = heapq.heappop(pq)

            if curr == self.target:
                return path, g

            # An exoume vrei idi kalytero dromo, agnooume auto to monopati
            if g > g_scores.get(curr, float('inf')):
                continue

            for op, next_val, cost in self.get_moves(curr):
                new_g = g + cost
                
                if next_val not in g_scores or new_g < g_scores[next_val]:
                    g_scores[next_val] = new_g
                    f_score = new_g + self.h(next_val)
                    new_step = (op, curr, cost)
                    heapq.heappush(pq, (f_score, next_val, path + [new_step], new_g))
        return None, 0

    def run(self, method):
        self.start_time = time.time()
        
        if method == "breadth":
            return self.run_bfs()
        elif method == "depth":
            return self.run_dfs()
        elif method == "best":
            return self.run_best_first()
        elif method == "astar":
            return self.run_astar()
        else:
            return None, 0

# --- File Writing ---

def save_to_file(filename, path, cost):
    try:
        with open(filename, 'w', encoding='utf-8') as f:
            if path is None:
                # An de brethei lusi de grafume tipota alliws ena minima 
                pass 
            else:
                # Format: N, C
                f.write(f"{len(path)}, {cost}\n")
                # Format: instruction number cost
                for op, val, c in path:
                    f.write(f"{op} {val} {c}\n")
    except IOError:
        print("Error writing to output file.")

# --- Main ---

def main():
    # Elegxos orismatwn grammis entolwn
    if len(sys.argv) != 5:
        print("Usage: python register_final.py <method> <start> <target> <output>")
        sys.exit(1)

    method = sys.argv[1].lower()
    
    try:
        start_val = int(sys.argv[2])
        target_val = int(sys.argv[3])
    except ValueError:
        print("Start and target must be integers.")
        sys.exit(1)
        
    output_file = sys.argv[4]

    # Dimiourgia tou solver
    # Time limit 60 sec opws leei h ekfwnisi
    solver = RegisterProblem(start_val, target_val, time_limit=60)
    
    print(f"Execution {method} from {start_val} to {target_val}.")
    
    # Metrisi xronou
    t0 = time.time()
    path, cost = solver.run(method)
    dt = time.time() - t0

    # Emfanisi apotelesmatwn
    if path is not None:
        print("Solved")
        print(f"Steps (N): {len(path)}")
        print(f"Total Cost (C): {cost}")
        print(f"Time: {dt:.4f} sec")
        save_to_file(output_file, path, cost)
    else:
        print("No solution found (Time limit exceeded).")

if __name__ == "__main__":
    main()