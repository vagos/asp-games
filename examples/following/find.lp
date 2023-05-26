#const t_end = 5.
dim(0..10).
t(0..t_end).
direction(up;down;left;right;front;back).

object(target).
object(self).

position(self,  vec3(0, 0, 0), 0). % UNCOMMENT THIS
position(target, vec3(0, 0, 10), 0).

0 { move(self, D, T) : direction(D) } 1 :- t(T).

position(O, vec3(X, Y - 1, Z), T + 1) :- object(O), position(O, vec3(X, Y, Z), T), move(O, up, T).
position(O, vec3(X, Y + 1, Z), T + 1) :- object(O), position(O, vec3(X, Y, Z), T), move(O, down, T).
position(O, vec3(X - 1, Y, Z), T + 1) :- object(O), position(O, vec3(X, Y, Z), T), move(O, left, T).
position(O, vec3(X + 1, Y, Z), T + 1) :- object(O), position(O, vec3(X, Y, Z), T), move(O, right, T).
position(O, vec3(X, Y, Z + 1), T + 1) :- object(O), position(O, vec3(X, Y, Z), T), move(O, front, T).
position(O, vec3(X, Y, Z - 1), T + 1) :- object(O), position(O, vec3(X, Y, Z), T), move(O, back, T).

position(O, vec3(X, Y, Z), T + 1) :- position(O, vec3(X, Y, Z), T), not move(O, _, T), t(T).

distance(D, T, O1, O2) :- position(O1, vec3(X1, Y1, Z1), T), position(O2, vec3(X2, Y2, Z2), T), D = |X1 - X2| + |Y1 - Y2| + |Z1 - Z2|.

#minimize { D : distance(D, t_end, self, target) }.

% goal :- position(self, vec3(X, Y, Z), T), position(target, vec3(X, Y, Z), T), T = t_end.
% :- not goal.

#show move/3.
