%%% Clingo program to program an agent playing football
#const t_end = 5.
#const kick_distance=2.
#const move_distance=2.

t(0..t_end).
direction(left;right;front;back).

object(self).
object(ball).
object(goal).
object(other_goal).

%% Define the locations of the players, ball, and goal
position(self,vec3(1,2,-19),0). 
position(ball,vec3(1,2,-14),0).
position(goal,vec3(0,2,-19),0).

% Object movement
position(O, vec3(X, Y - move_distance, Z), T + 1) :- position(O, vec3(X, Y, Z), T), move(O, up, T).
position(O, vec3(X, Y + move_distance, Z), T + 1) :- position(O, vec3(X, Y, Z), T), move(O, down, T).
position(O, vec3(X - move_distance, Y, Z), T + 1) :- position(O, vec3(X, Y, Z), T), move(O, left, T).
position(O, vec3(X + move_distance, Y, Z), T + 1) :- position(O, vec3(X, Y, Z), T), move(O, right, T).
position(O, vec3(X, Y, Z + move_distance), T + 1) :- position(O, vec3(X, Y, Z), T), move(O, front, T).
position(O, vec3(X, Y, Z - move_distance), T + 1) :- position(O, vec3(X, Y, Z), T), move(O, back, T).

position(O, vec3(X, Y - kick_distance, Z), T + 1) :- position(O, vec3(X, Y, Z), T), kick(OO, O, up, T).
position(O, vec3(X, Y + kick_distance, Z), T + 1) :- position(O, vec3(X, Y, Z), T), kick(OO, O, down, T).
position(O, vec3(X - kick_distance, Y, Z), T + 1) :- position(O, vec3(X, Y, Z), T), kick(OO, O, left, T).
position(O, vec3(X + kick_distance, Y, Z), T + 1) :- position(O, vec3(X, Y, Z), T), kick(OO, O, right, T).
position(O, vec3(X, Y, Z + kick_distance), T + 1) :- position(O, vec3(X, Y, Z), T), kick(OO, O, front, T).
position(O, vec3(X, Y, Z - kick_distance), T + 1) :- position(O, vec3(X, Y, Z), T), kick(OO, O, back, T).

% No action
position(O, vec3(X, Y, Z), T + 1) :- position(O, vec3(X, Y, Z), T), not move(O, _, T), not kick(_, O, _, T), t(T).

distance(O, O, 0, T) :- object(O), t(T).
distance(O1, O2, D, T) :- distance(O2, O1, D, T).
distance(O1, O2, D, T) :- position(O1, vec3(X1, Y1, Z1), T), position(O2, vec3(X2, Y2, Z2), T), D = |X1 - X2| + |Y1 - Y2| + |Z1 - Z2|.

:- kick(O, OO, _, T), distance(O, OO, D, T), D > 4.

0 { move(self, D, T) : direction(D) } 1 :- t(T).
0 { kick(self, ball, D, T) : direction(D) } 1 :- t(T).

% Change rule for the agent to have a different goal
#minimize { D : distance(ball, goal, D, t_end + 1) }.     % Agent that scores goal
% #minimize { D : distance(ball, friend, D, t_end + 1) }. % Agent that passes the ball
% #maximize { D : distance(ball, my_goal, D, t_end + 1) }.% Agent that protects goal
% #maximize { D : distance(self, enemy, D, t_end + 1) }.  % Agent that avoids enemy players 

#show move/3.
#show kick/4.
