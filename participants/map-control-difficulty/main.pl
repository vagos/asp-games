%%% A clingo program that generates levels of controllable difficulty.
%%% The countMoves(N) predicate counts the minimum number of moves that player should take.

#const n=3.

size(1..n,1..n).

start(1,1).
end(n,n).

item(banana).
item(mushroom).
item(wall).


1 {grid(X,Y,banana):size(X,Y)} 5 :- .

1 {grid(X,Y, mushroom):size(X,Y),  not grid(X,Y,banana) } 5 :- .

2 {grid(X,Y,wall):size(X,Y) , not grid(X,Y,I), item(I) , I != wall} 5 :- .

0{ grid(X,Y,air) } 1 :- size(X,Y).
:- not grid(X,Y,_) , size(X,Y).

:- grid(X,Y,wall) , start(X,Y).
:- grid(X,Y,wall) , end(X,Y).
:- grid(X,Y,air) , grid(X,Y,I) , item(I).

adjacent(X1,Y1,X2,Y2) :- |X1 - X2| == 1 , Y1==Y2, size(X1,Y1), size(X2,Y2).
adjacent(X1,Y1,X2,Y2) :- |Y1 - Y2| == 1 , X1==X2, size(X1,Y1), size(X2,Y2).

superAdjacent(X1,Y1,X2,Y2) :- |X1 - X2|<=2 , Y1==Y2 , size(X1,Y1) , size(X2,Y2).
superAdjacent(X1,Y1,X2,Y2) :- |Y1 - Y2|<=2 , X1==X2 , size(X1,Y1) , size(X2,Y2).

connected(X1,Y1, X2,Y2) :- adjacent(X1,Y1,X2,Y2) , not grid(X1,Y1,wall) , not grid(X2,Y2,wall).
connected(X1,Y1, X2,Y2) :- connected(X3,Y3,X2,Y2), adjacent(X1,Y1,X3,Y3), not grid(X3,Y3,wall).

:- not connected(1,1,n,n).

t(1..n*n).
tall(0..n*n).

player(1,1,0).

% exist(X,Y,banana, T+1) :- exist(X,Y,banana,T) , not player(X,Y,T1) , T1<=T, t(T) , t(T1). 
% exist(X,Y,mushroom, T+1) :- exist(X,Y,mushroom,T) , not player(X,Y,T1) , T1<=T, t(T) , t(T1). 

exist(X,Y,banana,T) :- exist(X,Y,banana,T-1) , not player(X,Y,T1) , T1 <= T , t(T) , t(T1).
exist(X,Y,mushroom,T) :- exist(X,Y,mushroom,T-1) , not player(X,Y,T1) , T1 <= T , tall(T), tall(T1).


exist(X,Y,banana,0) :- grid(X,Y,banana). 
exist(X,Y,mushroom,0) :- grid(X,Y,mushroom).


:- player(X,Y,T) , exist(X,Y,banana,T) , not player(X,Y,T+1).
ateMushroom(T):- player(X,Y,T) , exist(X,Y,mushroom,T).


0 { player(X,Y,T) : adjacent(X,Y,X1,Y1) , player(X1,Y1, T-1) , not grid(X,Y,wall)  } 1 :- t(T).
0 { player(X,Y,T) : ateMushroom(T-1) , player(X1,Y1, T-1) , superAdjacent(X,Y,X1,Y1) , not grid(X,Y,wall)}1 :- t(T).

win :- player(n,n,_).
:- not win.

countMoves(N):- N = #count {X,Y,T: player(X,Y,T)}.

#minimize { N : countMoves(N) }.
