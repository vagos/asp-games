%%% Clingo program to calculate wind direction inside grid.

#const n=5.

cell(1..n, 1..n).
x(1..n).
y(1..n).

% Initial Facts

mountain(1, 3).
mountain(2, 3).
mountain(3, 3).
mountain(4, 3).

wind(1, 1).
wind(2, 5).
wind(3, 5).
wind(4, 5).


% Around Wind Generators
around_wind(X, Y - 1)  :- wind(X, Y), cell(X, Y - 1).
around_wind(X + 1, Y - 1) :- wind(X, Y), cell(X + 1, Y - 1).
around_wind(X + 1, Y) :- wind(X, Y), cell(X + 1, Y).
around_wind(X + 1, Y + 1) :- wind(X, Y), cell(X + 1, Y + 1).
around_wind(X, Y + 1) :- wind(X, Y), cell(X, Y + 1).
around_wind(X - 1, Y + 1) :- wind(X, Y), cell(X - 1, Y + 1).
around_wind(X - 1, Y) :- wind(X, Y), cell(X - 1, Y).
around_wind(X - 1, Y - 1) :- wind(X, Y), cell(X - 1, Y - 1).

% D 1, 8

d(1..8).

% Wind Direction around Wind Generators
0 { wind_direction(X, Y - 1, 1) } 1  :- wind(X, Y), cell(X, Y - 1).
0 { wind_direction(X + 1, Y - 1, 2) } 1 :- wind(X, Y), cell(X + 1, Y - 1).
0 { wind_direction(X + 1, Y, 3) } 1 :- wind(X, Y), cell(X + 1, Y).
0 { wind_direction(X + 1, Y + 1, 4) } 1 :- wind(X, Y), cell(X + 1, Y + 1).
0 { wind_direction(X, Y + 1, 5) } 1 :- wind(X, Y), cell(X, Y + 1).
0 { wind_direction(X - 1, Y + 1, 6) } 1 :- wind(X, Y), cell(X - 1, Y + 1).
0 { wind_direction(X - 1, Y, 7) } 1 :- wind(X, Y), cell(X - 1, Y).
0 { wind_direction(X - 1, Y - 1, 8) } 1 :- wind(X, Y), cell(X - 1, Y - 1).

% Can't have wind on top of another entity.
entity(X, Y) :- wind(X, Y).
entity(X, Y) :- mountain(X, Y).
:- not wind_direction(X, Y, _), not entity(X, Y), around_wind(X, Y).


% Generate wind directions
1 { wind_direction(X, Y, D) : d(D) } 1 :- not around_wind(X, Y), not entity(X, Y), cell(X, Y).

adjacent(X, Y, X + 1, Y) :- x(X), y(Y).
adjacent(X, Y, X - 1, Y) :- x(X), y(Y).
adjacent(X, Y, X, Y + 1) :- x(X), y(Y).
adjacent(X, Y, X, Y - 1) :- x(X), y(Y).

diagonal(X, Y, X + 1, Y + 1) :- x(X), y(Y).
diagonal(X, Y, X - 1, Y - 1) :- x(X), y(Y).
diagonal(X, Y, X - 1, Y + 1) :- x(X), y(Y).
diagonal(X, Y, X + 1, Y - 1) :- x(X), y(Y).

small_change(D1, D2) :- d(D1), d(D2), |D1 - D2| <= 2.
small_change(D1, D2) :- d(D1), d(D2), |D1 - D2| >= 6.

% There can't be sudden changes between wind direction in adjacent cells
:- adjacent(X1, Y1, X2, Y2), wind_direction(X1, Y1, D1), wind_direction(X2, Y2, D2), not small_change(D1, D2).
:- diagonal(X1, Y1, X2, Y2), wind_direction(X1, Y1, D1), wind_direction(X2, Y2, D2), (D1 \ 4) == (D2 \ 4).
