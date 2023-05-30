import clorm
import clorm.clingo as clingo


class Cell(clorm.Predicate):
    x=clorm.IntegerField
    y=clorm.IntegerField
    n=clorm.IntegerField 


N = 4
# 
ctrl = clingo.Control(arguments=['-t 4', f"-c n={N}", "-n 0"], unifier=[Cell])
ctrl.load("main.pl")
ctrl.load("instance.pl")
# 
instace = clorm.FactBase()
ctrl.add_facts(instace)
ctrl.ground([("base",[])])
# 

def plot_map(cells):
    grid = [[0 for _ in range(N)] for _ in range(N)]

    for c in cells:
        x,y,t = c.x,c.y,c.n
        grid[N - y][x-1] = t

    for x in grid:
        for y in x:
            print(y ,end=" ")
        print()
    print()

   

def on_model(model):

    solution = model.facts(atoms=True)

    query=solution.query(Cell)\
        .order_by(Cell.x, Cell.y)

    plot_map(query.all())
    print("=" * 20)

ctrl.solve(on_model=on_model)
