import clorm
import clorm.clingo as clingo


class Grid(clorm.Predicate):
    x=clorm.IntegerField
    y=clorm.IntegerField
    name=clorm.ConstantField 

class Player(clorm.Predicate):
    x=clorm.IntegerField
    y=clorm.IntegerField
    t=clorm.IntegerField

N = 5
# 
ctrl = clingo.Control(arguments=['-t 4', f"-c n={N}",], unifier=[Grid, Player])
ctrl.load("main.pl")
# 
instace = clorm.FactBase()
ctrl.add_facts(instace)
ctrl.ground([("base",[])])
# 

def plot_map(cells, player):
    grid = [[None for _ in range(N)] for _ in range(N)]

    tiles = {
        'air' : "⬜",
        'mushroom' : '🍄',
        'banana': '🍌',
        'wall' : '🧱',
        'player': '😇',
    }

    for c in cells:
        x,y,t = c.x,c.y,c.name
        grid[y-1][x-1] = t
    
    for x in grid:
        for y in x:
            print(tiles[y] ,end="")
        print()
    print()
    grid = [['air' for _ in range(N)] for _ in range(N)]
    moves = [p for p in player]
    for m in moves:
        grid[m.y-1][m.x-1] = 'player'
    for x in grid:
        for y in x:
            print(tiles[y], end="")
        print()

def on_model(model):

    solution = model.facts(atoms=True)

    query=solution.query(Grid)\
        .order_by(Grid.x, Grid.y)
    player= solution.query(Player).order_by(Player.t)

    plot_map(query.all(), player.all())
    print("=" * 20)

ctrl.solve(on_model=on_model)
