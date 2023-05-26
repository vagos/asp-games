%%% Clingo program to place objects in a 3D space.

dim(0..20).

1 { place(O, X, Y, Z) : dim(X), dim(Y), dim(Z) } 1 :- object(O).
floor(X, Y, 0) :- dim(X), dim(Y).

in(O, IX, IY, IZ) :- place(O, X, Y, Z), size(O, SX, SY, SZ), 
                     X <= IX, X + SX > IX,
                     Y <= IY, Y + SY > IY,
                     Z <= IZ, Z + SZ > IZ,
                     dim(IX), dim(IY), dim(IZ).

on(O1, O2) :- in(O2, X, Y, Z), size(O2, SX, SY, SZ), in(O1, X, Y + SY, Z).
% O1 -> O2

volume(O, N) :- size(O, X, Y, Z), N = X * Y * Z.

:- in(O1, X, Y, Z), in(O2, X, Y, Z), O1 != O2.
:- place(O, X, Y, Z), Y > 0, 0 { in(OO, X, Y - 1, Z) } 0.
:- on(O1, O2), volume(O1, V1), volume(O2, V2), V1 >= V2.

#show place/4.
