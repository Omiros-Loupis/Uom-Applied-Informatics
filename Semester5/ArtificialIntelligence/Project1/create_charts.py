import matplotlib.pyplot as plt
import numpy as np

# Ρυθμίσεις για να φαίνονται ωραία τα ελληνικά (αν δεν εμφανίζονται, άστο στα αγγλικά)
plt.style.use('ggplot')

# --- Διάγραμμα 1: Το μεγάλο Stress Test (2 -> 1000) ---
# Σύγκριση Κόστους (C)
algs = ['BFS', 'Best-First', 'A*']
costs_1000 = [496, 501, 311] # Τα νούμερα από τα αρχεία σου (bfs3, best3, astar3)

plt.figure(figsize=(8, 5))
bars = plt.bar(algs, costs_1000, color=['#ff9999', '#66b3ff', '#99ff99'])
plt.title('Πρόβλημα 2 -> 1000: Σύγκριση Κόστους (C)')
plt.ylabel('Συνολικό Κόστος')
for bar in bars:
    yval = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2, yval + 5, int(yval), ha='center', va='bottom')
plt.savefig('chart_1000_cost.png', dpi=300)
print("Έτοιμο το 1ο διάγραμμα!")

# --- Διάγραμμα 2: Ποιότητα Λύσης (2 -> 97) ---
# Σύγκριση Βημάτων (N) vs Κόστος (C)
labels = ['BFS', 'A*']
steps_97 = [6, 7]      # bfs6 vs astar6
costs_97 = [44, 35]    # bfs6 vs astar6

x = np.arange(len(labels))
width = 0.35

fig, ax = plt.subplots(figsize=(8, 5))
rects1 = ax.bar(x - width/2, steps_97, width, label='Βήματα (N)', color='skyblue')
rects2 = ax.bar(x + width/2, costs_97, width, label='Κόστος (C)', color='orange')

ax.set_ylabel('Τιμές')
ax.set_title('Πρόβλημα 2 -> 97: BFS vs A*')
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend()

def autolabel(rects):
    for rect in rects:
        height = rect.get_height()
        ax.annotate('{}'.format(height),
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 3), textcoords="offset points", ha='center')

autolabel(rects1)
autolabel(rects2)
plt.savefig('chart_97_comparison.png', dpi=300)
print("Έτοιμο το 2ο διάγραμμα!")

# --- Διάγραμμα 3: Η "Εξυπνάδα" του A* (2 -> 31) ---
# Σύγκριση Κόστους σε λεπτομέρεια
algs_small = ['BFS', 'Best-First', 'A*']
costs_31 = [17, 17, 16] # bfs5, best5, astar5

plt.figure(figsize=(8, 5))
bars = plt.bar(algs_small, costs_31, color=['gray', 'gray', 'gold'])
plt.title('Πρόβλημα 2 -> 31: Λεπτομέρεια Κόστους')
plt.ylim(10, 20) # Zoom in για να φανεί η διαφορά
for bar in bars:
    yval = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2, yval + 0.1, int(yval), ha='center', va='bottom')
plt.savefig('chart_31_smart.png', dpi=300)
print("Έτοιμο το 3ο διάγραμμα!")