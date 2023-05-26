%%% Clingo program that plays a simplified version of the Ball-Sort game.
#const maxtime=4.

vase(1..4).

vase(1, 4, 0).
vase(2, 4, 0).
vase(3, 0, 0).
vase(4, 0, 0).

t(0..maxtime).

0 { move(X, Y, T) : vase(X), vase(Y) } 1 :- t(T).

vase(V1, N1 - 1, T + 1) :- move(V1, V2, T), vase(V1, N1, T), vase(V2, N2, T).
vase(V2, N2 + 1, T + 1) :- move(V1, V2, T), vase(V1, N1, T), vase(V2, N2, T).

vase(V, N, T + 1) :- not move(V, _, T), not move(_, V, T), vase(V, N, T), t(T).

:- vase(V), vase(V, N, T), N > 4.
:- vase(V), vase(V, N, T), N < 0.
:- move(V, V, T), t(T).

vasesWithGoalBalls(N, T) :- N = #count { V : vase(V, 2, T) }, t(T). 

goal :- vasesWithGoalBalls(N, maxtime), N == 4.
:- not goal.

#show vase/3.
#show move/3.
