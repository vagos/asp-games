Data from the user study:

| Application              | Description                                   | Applicability Heuristic | Duration | Iterations |
|--------------------------|-----------------------------------------------|-------------------------|----------|------------|
| Wind Direction Simulator | Simulate wind direction in a grid.            | **B, E**                | 2.5h     | 3          |
| Loot Generator           | Generates reward combinations.                | **B, S**                | 1h       | 2          |
| Conversational Agent     | Simulate a conversation.                      | **S, E**                | 2h       | 4          |
| Space Traversing Agent   | Agent that can navigate a 2D space.           | **B**                   | 1h       | 2          |
| Level Generator          | Generates game levels                         | **B, E**                | 2h       | 5          |
| *Ball Sort* Solver       | Solves/Generates instances of puzzle game.    | **B, S**                | 1h       | 2          |
| *Futoshiki* Solver       | Solves/Generates instances of puzzle game     | **B, S**                | 0.5h     | 2          |
| Level Generator          | Generate levels with controllable difficulty. | **B, E**                | 3h       | 6          |

The applicability heuristics are:

- **B**revity
- Relatively **S**mall solution space
- **E**mergent complexity

Duration measures the total development time. A single iteration is defined as
the process of inspecting the program's produced answer sets and making one or
more significant modifications.
