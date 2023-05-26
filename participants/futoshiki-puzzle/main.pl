%%% A clingo program that solves instances of the Futoshiki puzzle (https://www.futoshiki.com/).

#const n = 4.
% cell(X, Y, N)

value(1..n).
size(1..n, 1..n).

0 { cell(X, Y, N) : value(N) } 1 :- size(X, Y).

:- cell(X1, Y, N), cell(X2, Y, N), X1 != X2.
:- cell(X, Y1, N), cell(X, Y2, N), Y1 != Y2.

:- cell(X, Y, N1), cell(X, Y, N2), N1 != N2.

:- less_than(X1, Y1, X2, Y2), cell(X1, Y1, V1), cell(X2, Y2, V2), V1 >= V2.

:- size(X, Y), not cell(X, Y, _).

#show cell/3.
