import clorm
import clorm.clingo as clingo

import math
import random
import sys
import time

class CellType(clorm.Predicate):
    name=clorm.ConstantField

class Cell(clorm.Predicate):
    x=clorm.IntegerField
    y=clorm.IntegerField
    name=clorm.ConstantField

class Tile:
    def __init__(self, x, y, name):
        self.x = x
        self.y = y
        self.name = name

N = 16
n = 4
N_sqrt = int(math.sqrt(N))


cell_types = [CellType(t) for t in ["wood", "water", "grass"]]
cells = []
instace = clorm.FactBase(cell_types + cells)

def plot_map(all_cells):

    print(f"# ImageMagick pixel enumeration: {N_sqrt * n},{N_sqrt * n},0,255,srgb")

    colors = {'wood': (219, 148, 88), 'water': (0, 0, 255), 'grass': (0, 200, 0),
              'lava' : (200, 0, 0), 'sand' : (235, 140, 52),
              }

    for c in all_cells:
        x, y, t = c.x, c.y, c.name
        color = colors[t]

        print(f"{x},{y}: {color}")

models = []

def on_model(model):
    models.append(model.facts(atoms=True))

all_cells_list = []

t_total = 0


for i in range(N):
    i_x = i % N_sqrt
    i_y = i // N_sqrt

    models.clear()

    ctrl = clingo.Control(arguments=["-t 4", "-n 2000", f"-c n={n}", "--rand-freq=0.1"], unifier=[CellType, Cell])
    ctrl.load("main.pl")

    print(f"Generating map {i + 1}/{N}", file=sys.stderr)

    ctrl.add_facts(instace)

    rnd_lavas = clingo.Number(random.randint(1, 3))
    
    if i_x == i_y:
        ctrl.ground([("base", []), ("connected",[])])
    else:
        ctrl.ground([("base",[]), ("lava", [rnd_lavas])])

    t1 = time.time()
    
    ctrl.solve(on_model=on_model)
    solution = random.choice(models)

    t2 = time.time()

    print("Solving time: ", t2 - t1, file=sys.stderr)

    t_total += (t2 - t1)

    query=solution.query(Cell)\
        .order_by(Cell.x, Cell.y)\

    cells = query.all()

    for c in cells:
        x, y = c.x, c.y

        X = i_x * n + x - 1
        Y = i_y * n + y - 1

        all_cells_list.append(Tile(X, Y, c.name))

all_cells_list.sort(key=lambda c : (c.x, c.y))
plot_map(all_cells_list)

print("Average solving time: ", t_total / N, file=sys.stderr)
