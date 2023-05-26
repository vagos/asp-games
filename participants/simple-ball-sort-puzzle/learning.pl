person(bob).
person(anna).
house(tent).
house(cave).

1 { chosen(X, Y) : person(X) } 1 :- house(Y).
:- chosen(X, Y), chosen(Z, Y), X == Y.
