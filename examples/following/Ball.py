# Example Python glue code to use inside Godot

from godot import exposed, export
from godot import *
import godot

import ClingoObject as co
import clorm.clingo as clingo
import clorm
import queue

class Position(clorm.Predicate):
    object_ = clorm.ConstantField
    pos = co.Vector3Field.Field
    t = clorm.IntegerField

@exposed
class Ball(co.ClingoObject, godot.RigidBody):

    def _ready(self):
        co.ClingoObject._ready(self)
        self.think_queue = queue.Queue(maxsize=10)

    def _think(self):
        def on_model(model):
            solution = model.facts(atoms=True)
            query = solution.query(co.Move)\
                            .where(co.Move.time == 0) # get only the move that must be done first
            model = list(query.all())
            
            self.think_queue.put(model)

        ctrl = clingo.Control(arguments=["--opt-mode=opt"], unifier=[co.Move, co.Direction, Position])

        target = self.get_tree().get_root().get_node("Spatial/Player")
        goal = self.get_tree().get_root().get_node("Spatial/Room").get_node("GoalLeft").get_global_transform().origin

        facts = [
                Position("self", co.Vector3(self.translation), 0),
                Position("target", co.Vector3(target.translation), 0),
        ]

        instance = clorm.FactBase(facts)

        ctrl.add_facts(instance)
        ctrl.load(self.clingo_file) # find.pl file
        ctrl.ground([("base", [])])

        ctrl.solve(on_model=on_model)

    def act(self, delta, model):
        return
        if len(model) == 0: return

        atom = model[0]

        text_scene = godot.load("res://scenes/Text.tscn")

        direction_vector = godot.Vector3(0, 0, 0)

        if atom.direction == 'up':
            direction_vector = godot.Vector3(0, 1, 0)
        if atom.direction == 'down':
            direction_vector = godot.Vector3(0, -1, 0)
        if atom.direction == 'left':
            direction_vector = godot.Vector3(-1, 0, 0)
        if atom.direction == 'right':
            direction_vector = godot.Vector3(1, 0, 0)
        if atom.direction == 'front':
            direction_vector = godot.Vector3(0, 0, 1)
        if atom.direction == 'back':
            direction_vector = godot.Vector3(0, 0, -1)

        force = 100
        self.apply_impulse(godot.Vector3(0,0,0), direction_vector * delta * force) 

    def _physics_process(self, delta):
        if (self.think_queue.empty()): return

        think_model = self.think_queue.get()
        self.act(delta, think_model)
