#const n=5.
#const m=20.

t(0..m).
x(1..n).
y(1..n).

grid(2, 2, mushroom).
grid(2..4, 3, wall).
grid(5, 1, banana).
grid(4,4, banana).
grid(2,5, banana).


person(3,1,0).

goal:- person(1,5, T), t(T).
:- not goal.

1 {move(X,Y,T):x(X),y(Y)} 1:- t(T).

person(X,Y+1,T+1):-person(X,Y,T), move(X,Y+1,T).
person(X+1,Y,T+1):-person(X,Y,T), move(X+1,Y,T).
person(X,Y-1,T+1):-person(X,Y,T), move(X,Y-1,T).
person(X-1,Y,T+1):-person(X,Y,T), move(X-1,Y,T).

:-grid(X,Y,_),person(X,Y,_).

#minimize {T,X,Y:person(X,Y,T)}.
