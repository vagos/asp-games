%%% Clingo program that places tiles in a grid.

#program base.

#const n=5.
#const k=2.

cellType(grass;wood;water;lava;sand).

x(1..n).
y(1..n).

:- cell(X, Y, _), not x(X).
:- cell(X, Y, _), not x(Y).

1 { cell(X, Y, T): cellType(T) } 1 :- x(X), y(Y).

adjacent(X, Y, X + 1, Y) :- x(X), y(Y).
adjacent(X, Y, X - 1, Y) :- x(X), y(Y).
adjacent(X, Y, X, Y + 1) :- x(X), y(Y).
adjacent(X, Y, X, Y - 1) :- x(X), y(Y).

connected(X, Y, X1, Y1) :- adjacent(X, Y, X1, Y1), cell(X, Y, T), cell(X1, Y1, T).
connected(X, Y, X1, Y1) :- connected(X, Y, X2, Y2), connected(X1, Y1, X2, Y2).

:- cell(X1, Y1, lava), cell(X2, Y2, water), adjacent(X1, Y1, X2, Y2).

#program lava(k).

cellCount(N, T) :- cellType(T), N = #count { X, Y : cell(X, Y, T) }.
:- cellCount(N, lava), N < 1.
:- cellCount(N, grass), N < 10.

#program connected. 
cell(1, 1, water).
:- not connected(1, 1, n, n).

%!show_trace cell(X, Y, T).
