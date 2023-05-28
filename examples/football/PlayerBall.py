"""
Game Object code for Football Player for Godot.
"""

from godot import exposed, export
from godot import *
import godot
from godot import exposed, export, Vector2, Node2D, ResourceLoader

import ClingoObject as co
import clorm.clingo as clingo
import clorm
import queue
import random
import xclingo.__main__

TEXT_SCENE = ResourceLoader.load("res://scenes/Text.tscn")

class Position(clorm.Predicate):
    object_ = clorm.ConstantField
    pos = co.Vector3Field.Field
    t = clorm.IntegerField

class Kick(clorm.Predicate):
    obj = clorm.ConstantField
    other_obj = clorm.ConstantField
    direction = clorm.ConstantField
    time = clorm.IntegerField

class Enemy(clorm.Predicate):
    obj = clorm.ConstantField

@exposed
class PlayerBall(co.ClingoObject, godot.RigidBody):

    target_goal = export(str, default='GoalLeft')

    def _ready(self):
        co.ClingoObject._ready(self)

    def _think(self):
        models = []
        def on_model(model):
            solution = model.facts(atoms=True)
            move_query = solution.query(co.Move)\
                            .where(co.Move.time < 5) # get only the move that must be done first
            kick_query = solution.query(Kick)\
                             .where(Kick.time < 5) # get only the move that must be done first
            
            move_model = list(move_query.all())
            kick_model = list(kick_query.all())

            models.append(move_model + kick_model)

        ctrl = clingo.Control(arguments=["--opt-mode=opt"], unifier=[co.Move, co.Direction, Position, Kick])

        enemy_name = 'RedPlayer' if self.target_goal == 'GoalLeft' else 'BluePlayer'
        my_goal_name = 'GoalRight' if self.target_goal == 'GoalLeft' else 'GoalLeft'

        ball = self.get_tree().get_root().get_node("Main/FootballMatch").get_node("Ball"); self.ball = ball
        goal = self.get_tree().get_root().get_node("Main/FootballMatch").get_node("Room").get_node(self.target_goal).get_global_transform()
        my_goal = self.get_tree().get_root().get_node("Main/FootballMatch").get_node("Room").get_node(my_goal_name).get_global_transform()
        enemy = self.get_tree().get_root().get_node("Main/FootballMatch").get_node(enemy_name)
        # friend_player = self.get_tree().get_root().get_node("Main/FootballMatch").get_node("BluePlayer")

        facts = [
                Position("self", co.Vector3(self.translation), 0),
                Position("ball", co.Vector3(ball.translation), 0),
                Position("goal", co.Vector3(goal.origin), 0),
                Position("other_goal", co.Vector3(my_goal.origin), 0),
        ]

        players = self.get_tree().get_nodes_in_group("Players")
        for player in players:
            if player == self: continue
            facts.append(Position(str(player.name), co.Vector3(player.translation), 0))

        instance = clorm.FactBase(facts)

        ctrl.add_facts(instance)
        ctrl.load(self.clingo_file)
        ctrl.ground([("base", [])])

        ctrl.solve(on_model=on_model)

        self.think_queue.put(models[-1])

    def act(self, delta, model):
        if len(model) == 0: return

        # Floating text showing the agent's last thought.
        text = TEXT_SCENE.instance()
        self.get_parent().add_child(text)
        text.translation = self.translation
        text.set_text(str(model))
        
        for atom in model:

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

            if isinstance(atom, co.Move):
                self.apply_impulse(godot.Vector3(0,0,0), direction_vector * delta * force * 50) 

            if isinstance(atom, Kick) and self.translation.distance_to(self.ball.translation) <= 2:
                self.ball.apply_impulse(godot.Vector3(0,0,0), direction_vector * delta * force * 5)

    def _physics_process(self, delta):
        if self.think_queue.empty(): return

        think_model = self.think_queue.get()
        self.act(delta, think_model)
