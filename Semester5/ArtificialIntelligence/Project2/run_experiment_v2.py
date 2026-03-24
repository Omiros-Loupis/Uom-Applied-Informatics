import os
import subprocess
import re
import matplotlib.pyplot as plt
import numpy as np
import sys
import glob

# --- ΡΥΘΜΙΣΕΙΣ ΠΕΙΡΑΜΑΤΟΣ (ΠΑΡΑΜΕΤΡΟΙ) ---
# Επιλέγουμε N=20 για πιο ξεκάθαρα διαγράμματα χρόνου.
# K=4 όπως ζητήθηκε (Phase transition αναμένεται στο M/N ~ 9.9)
N_VAL = 20          
K_VAL = 4           
RATIOS = np.arange(2.0, 15.0, 1.0) # Από 2 έως 14
SAMPLES_PER_RATIO = 10             # Πόσα προβλήματα ανά λόγο (10-20 είναι καλά)

# Ονόματα αρχείων
GEN_SRC = 'bcsp_generate.c'
SOLVER_SRC = 'bcsp.c'
GEN_EXE = 'generator' if os.name != 'nt' else 'generator.exe'
SOLVER_EXE = 'solver' if os.name != 'nt' else 'solver.exe'

def check_files():
    if not os.path.exists(GEN_SRC) or not os.path.exists(SOLVER_SRC):
        print("ΣΦΑΛΜΑ: Δεν βρέθηκαν τα αρχεία .c (bcsp_generate.c, bcsp.c).")
        sys.exit(1)

def compile_generator(n, m, k):
    """
    Διαβάζει τον generator, αλλάζει τα #define και κάνει compile.
    """
    with open(GEN_SRC, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Αντικατάσταση των σταθερών στον κώδικα C
    content = re.sub(r'#define N \d+', f'#define N {n}', content)
    content = re.sub(r'#define M \d+', f'#define M {m}', content)
    content = re.sub(r'#define K \d+', f'#define K {k}', content)
    
    temp_src = 'bcsp_generate_temp.c'
    with open(temp_src, 'w', encoding='utf-8') as f:
        f.write(content)
        
    # Compile (σιωπηλά)
    ret = subprocess.run(["gcc", temp_src, "-o", GEN_EXE], capture_output=True)
    if ret.returncode != 0:
        print(f"Compilation Error in Generator:\n{ret.stderr.decode()}")
        sys.exit(1)

def compile_solver():
    """
    To solver (bcsp.c) είναι δυναμικό, το κάνουμε compile μια φορά.
    """
    print("Compiling solver...")
    ret = subprocess.run(["gcc", SOLVER_SRC, "-o", SOLVER_EXE], capture_output=True)
    if ret.returncode != 0:
        print(f"Compilation Error in Solver:\n{ret.stderr.decode()}")
        sys.exit(1)

def run_solver(method, input_file, output_file):
    """
    Τρέχει τον solver και επιστρέφει (λύθηκε?, χρόνος).
    """
    cmd = [f"./{SOLVER_EXE}" if os.name != 'nt' else SOLVER_EXE, method, input_file, output_file]
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=120) # Safety timeout
        output = result.stdout
    except subprocess.TimeoutExpired:
        return False, 60.0 # Αν κολλήσει τελείως
    
    # Parse χρόνου
    time_spent = 0.0
    # Ψάχνουμε το "Time spent: X.XXXX secs"
    time_match = re.search(r'Time spent:\s+(\d+(\.\d+)?)', output)
    if time_match:
        time_spent = float(time_match.group(1))
        
    # Έλεγχος αν βρέθηκε λύση
    solved = "Solution found" in output
    
    return solved, time_spent

def cleanup():
    """Καθαρίζει τα προσωρινά αρχεία."""
    files_to_remove = glob.glob("prob_*.txt") + glob.glob("*.exe") + \
                      ["out.txt", "bcsp_generate_temp.c", "generator", "solver"]
    for f in files_to_remove:
        if os.path.exists(f):
            try:
                os.remove(f)
            except:
                pass

# --- MAIN SCRIPT ---
def main():
    check_files()
    cleanup() # Καθαρισμός από προηγούμενα runs
    compile_solver()
    
    print(f"\n--- ΕΝΑΡΞΗ ΠΕΙΡΑΜΑΤΟΣ (N={N_VAL}, K={K_VAL}) ---")
    print(f"{'Ratio':<8} {'M':<6} {'P(SAT)':<10} {'Avg Time (DFS)':<15} {'Avg Time (Hill)':<15}")
    print("-" * 60)

    results_prob = []
    results_time_dfs = []
    results_time_hill = []

    for ratio in RATIOS:
        M_VAL = int(ratio * N_VAL)
        
        # 1. Δημιουργία Generator για το συγκεκριμένο M
        compile_generator(N_VAL, M_VAL, K_VAL)
        
        # 2. Παραγωγή προβλημάτων (prob_1.txt ... prob_10.txt)
        subprocess.run([f"./{GEN_EXE}" if os.name != 'nt' else GEN_EXE, "prob", "1", str(SAMPLES_PER_RATIO)], check=True)
        
        sat_count = 0
        times_dfs = []
        times_hill = []
        
        for i in range(1, SAMPLES_PER_RATIO + 1):
            filename = f"prob_{i}.txt"
            outfile = "out.txt"
            
            # --- DFS Execution ---
            # Χρησιμοποιούμε τον DFS για να κρίνουμε αν είναι Satisfiable
            # γιατί ο Hill Climbing μπορεί να αποτύχει ακόμα και αν υπάρχει λύση.
            solved_dfs, t_dfs = run_solver("depth", filename, outfile)
            times_dfs.append(t_dfs)
            
            if solved_dfs:
                sat_count += 1
            
            # --- Hill Climbing Execution ---
            # Τρέχουμε 5 φορές και παίρνουμε τον μέσο όρο
            # όπως ζητάει η εκφώνηση για το διάγραμμα χρόνου.
            run_times = []
            for _ in range(5):
                _, t_hill = run_solver("hill", filename, outfile)
                run_times.append(t_hill)
            times_hill.append(sum(run_times) / 5.0)

        # Υπολογισμός στατιστικών
        prob = sat_count / SAMPLES_PER_RATIO
        avg_dfs = sum(times_dfs) / len(times_dfs)
        avg_hill = sum(times_hill) / len(times_hill)
        
        results_prob.append(prob)
        results_time_dfs.append(avg_dfs)
        results_time_hill.append(avg_hill)
        
        print(f"{ratio:<8.1f} {M_VAL:<6} {prob:<10.1f} {avg_dfs:<15.4f} {avg_hill:<15.4f}")

    # --- PLOTTING ---
    plt.style.use('ggplot') # Πιο όμορφο στυλ γραφημάτων
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

    # Γράφημα 1: Πιθανότητα Ικανοποίησης
    ax1.plot(RATIOS, results_prob, 'o-', color='tab:blue', linewidth=2, label='P(Satisfiable)')
    ax1.axvline(x=9.9, color='red', linestyle='--', alpha=0.5, label='Theoretical Threshold (K=4)')
    ax1.set_title(f'Probability of Satisfiability (K={K_VAL}, N={N_VAL})')
    ax1.set_xlabel('Ratio M/N')
    ax1.set_ylabel('Probability P')
    ax1.set_ylim(-0.05, 1.05)
    ax1.legend()
    ax1.grid(True)

    # Γράφημα 2: Χρόνος Εκτέλεσης
    ax2.plot(RATIOS, results_time_dfs, 'x-', color='tab:red', label='DFS (Complete)')
    ax2.plot(RATIOS, results_time_hill, '^-', color='tab:green', label='Hill Climbing (Stochastic)')
    ax2.set_title('Average Execution Time')
    ax2.set_xlabel('Ratio M/N')
    ax2.set_ylabel('Time (sec)')
    ax2.legend()
    ax2.grid(True)
    
    # Προσθήκη σχολίου για Phase Transition
    fig.suptitle(f'Phase Transition in Random {K_VAL}-SAT', fontsize=16)
    
    output_png = 'sat_phase_transition.png'
    plt.savefig(output_png)
    print(f"\nΟλοκληρώθηκε! Το γράφημα αποθηκεύτηκε ως '{output_png}'.")
    
    # Καθαρισμός στο τέλος
    cleanup()

if __name__ == "__main__":
    main()