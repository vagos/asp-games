%%% A clingo program that generates maps for a "Spiral Knights"-like game.

#const n = 5.
% tile(X, Y, T).

size(1..n, 1..n).
type(permanent).
type(destructible).
type(collapsable).
type(mob).
type(bomb).
type(loot).
type(empty).

entrance(1, 1).
exit(n, n).

1 {  tile(X, Y, T) : type(T) } 1 :- size(X, Y). 

adjacent(X, Y, X + 1, Y) :- size(X, Y). 
adjacent(X, Y, X - 1, Y) :- size(X, Y). 
adjacent(X, Y, X, Y + 1) :- size(X, Y). 
adjacent(X, Y, X, Y - 1) :- size(X, Y).

:- adjacent(X1, Y1, X2, Y2), tile(X1, Y1, mob), tile(X2, Y2, mob).
:- adjacent(X1, Y1, X2, Y2), tile(X1, Y1, bomb), tile(X2, Y2, bomb).

count_adjacent(X, Y, N) :- tile(X, Y, T), N = #count { XO, YO : tile(XO, YO, T), adjacent(X, Y, XO, YO) }.
count_combos(N) :- N = #count { XO, YO : tile(X, Y, mob), adjacent(X, Y, XO, YO), tile(XO, YO, bomb) }, size(X, Y).
count_tile(T, N) :- type(T), N = #count { X, Y: tile(X, Y, T), size(X, Y)}.

:- tile(X, Y, collapsable), count_adjacent(X, Y, N), N < 2.
:- tile(X, Y, loot), count_adjacent(X, Y, N), N < 1.
:- tile(X, Y, permanent), count_adjacent(X, Y, N), N < 1.
:- count_tile(loot, N), N < 4.
:- count_tile(loot, N), N > n - 1.
:- count_tile(collapsable, N), N < n.
:- count_tile(mob, N), N < 1.

passable(X, Y) :- not tile(X, Y, permanent), size(X, Y).

connected(X, Y, X1, Y1) :- adjacent(X, Y, X1, Y1), passable(X, Y), passable(X1, Y1).
connected(X, Y, X1, Y1) :- connected(X, Y, X2, Y2), connected(X1, Y1, X2, Y2).

:- not connected(XS, YS, XE, YE), entrance(XS, YS), exit(XE, YE).

:- entrance(X, Y), not tile(X, Y, empty).
:- exit(X, Y), not tile(X, Y, empty).

:- count_tile(permanent, N), N < 2 * n + 3.

:- tile(X, Y, loot), not connected(X, Y, XS, YS), entrance(XS, YS).

#maximize { N : count_combos(N) }.
