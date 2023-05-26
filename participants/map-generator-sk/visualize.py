import clorm
import clorm.clingo as clingo

class Tile(clorm.Predicate):
    x=clorm.IntegerField
    y=clorm.IntegerField
    name=clorm.ConstantField 

N = 6
X = N
Y = N

ctrl = clingo.Control(arguments=["-n 0", "-t 4", f"-c n={N}",], unifier=[Tile])
ctrl.load("main.pl")

instace = clorm.FactBase()

ctrl.add_facts(instace)
ctrl.ground([("base",[])])

def plot_map(cells):
    grid = [[None for _ in range(N)] for _ in range(N)]

    colors = { "loot": '💰', 'bomb': '💣', 'mob': '👾', 'collapsable': '💔', 'empty':'⬜', 
    'destructible': '🟫', 'permanent':'🧱' }

    for c in cells:
        x, y, t = c.x, c.y, c.name
        color = colors[t]
        grid[y - 1][x - 1] = c

    for y in range(N):
        for x in range(N):
            c = grid[y][x]
            print(colors[c.name], end='')
        print()


def on_model(model):

    solution = model.facts(atoms=True)

    query=solution.query(Tile)\
        .order_by(Tile.x, Tile.y)\

    plot_map(query.all())
    print("=" * 20)

ctrl.solve(on_model=on_model)
