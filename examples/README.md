## Football Agents Game

Files in `football`.

We developed a game scenario that showcases how ASP can model two teams of
adversarial agents and how the result is both interesting and appropriate. Our
method avoids the need to implement path-finding algorithms like A* or the
application of reinforcement learning techniques which can be hard to develop
and debug during game prototyping. The characteristics of **relatively small
solution space** and **emergent complexity** are present in this case study.
The solution space can be controlled by reducing the number of time-steps the
agent will "see" in the future. Emergent complex behavior arises as the agent
is not explicitly instructed to kick the ball for goal scoring. Instead,
logical rules describe how the ball's location changes upon agent actions,
enabling the ASP solver to derive a winning strategy.

1. In this case study, the input atoms are the location of critical game world objects like the location of the ball,
the two goals, and the other players. Output atoms will be the agent’s decisions of where to move, whether
they will kick the ball and towards which direction.
2. We add choice rules for the agent’s possible actions. At this point, we integrate the solver inside the Godot [17]
game engine, translating the output atoms into actions inside the game world.
3. We finally add integrity constraints, making the agents avoid colliding with each other as well as an optimization
directive that tries to minimize the ball’s distance to the enemy’s goal. The sequence of actions an agent will
take will be the ones that bring the ball closer to the goal.

<img alt="A top-down screenshot of the football playing field." src=/assets/field.png width=50%>
<img alt="The football players. The floating text above the agent indicates the agent's latest "thought", which is the action it will perform next." src=/assets/field_close_facts.png width=50%>

## Tile-Level Terrain Generation

Files in `tile-generation`.

With terrain generation, games often follow an approach where a noise function like Perlin noise is used to
determine the type of terrain to be placed at some specific `(x,y)` location. This approach has seen major adoption in
the game industry as it is used in major titles like [Minecraft](https://minecraft.fandom.com/wiki/Noise_generator). However, this approach although performant, does
not allow for high levels of controllability. For example, a designer cannot specify that they want a certain number of
mountains to be placed, or a river that flows through a specific area. Using ASP, we can generate natural-looking terrain
using a highly expressive language. The ASP applicability heuristics of brevity and emergent complexity are present
in this example. In our ASP program, the placement of tiles inside the grid can be encoded in a single-choice rule. Then,
through integrity constraints, we add rules that propagate through the entire grid, creating interesting patterns.

The application of our proposed methodology works as follows:

1. Determine output atoms, which are the type of tile in each of the grid’s locations (an atom of the form
`tile(x,y,type)`). Input atoms consist of predicates that will control certain aspects of the generation. For
example, the programmer could input a single fact of the form `tile(1, 1, water)` which will force the generator
to place the specific type of tile on that location.
2. Add a single choice rule that places a tile of random type at every grid space. At this point, we also develop a
script that takes the output of the solver and translates the output atoms into colored pixels.
3. The generator’s output is controlled using integrity constraints. In our example, we added constraints where no
“water” and “lava” tiles can touch while there must also be a river flowing along the diagonal.

![A generated map with no constraints encoded.](/assets/no_constraints.png)
![A generated map with a river flowing through it and no water and lava tiles touching (inside the same sub-grid).](/assets/all_constraints.png)

## Extra

More examples can be found in the `extra` folder. 

These examples include applications of ASP in scenarios like: 

- Path-finding (`following.pl`)
- Automatic object placement for scene generation (`place.pl`)
- Goal-oriented room traversal (`room-traversal`)
