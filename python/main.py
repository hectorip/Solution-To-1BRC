import csv
from collections import defaultdict

def default_tuple():
    # 0: count, 1: sum, 2: min, 3: max
    return (0, 0, 0, 0)
def main():
    sums = defaultdict(default_tuple)

    with open('../../measurements.txt', 'r') as file:
        reader = csv.reader(file, delimiter=";")
        for row in reader:
            c = sums[row[0]]
            n = float(row[1])
            sums[row[0]] = (
                c[0] + 1,
                c[1] + n,
                min(c[2], n),
                max(c[3], n),
            )
    print(sums)
    # Falta sacar los promedios y odenarlos

main()
