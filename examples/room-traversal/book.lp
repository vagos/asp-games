%%% Clingo program for programming an agent that can pick up objects and move from one room to another in order to complete a goal.
%%% Agent's AI is based on Discrete Event Calculus axioms.
%%% Agent is capable of doing high level reasoning.

% No fluents can be released at time 0
:- releasedAt(F,0), fluent(F).

% Generate possible events/fluents
event(letGoOf(A,O)) :- agent(A), object(O).
event(pickUp(A,O)) :- agent(A), object(O).
event(walk(A,R1,R2)) :- agent(A), room(R1), room(R2), R1 != R2.
event(unlock(A, R)) :- agent(A), room(R).
fluent(inRoom(O,R)) :- object(O), room(R).
fluent(holding(A,O)) :- agent(A), object(O).
fluent(locked(R)) :- room(R).

% When an agent walks from room R1 to room R2, they start being in room R2
initiates(walk(A,R1,R2),inRoom(A,R2),T) :-
  agent(A), room(R1), room(R2), time(T), not holdsAt(locked(R2), T).

% When an agent walks from room R1 to room R2, they stop being in room R1
terminates(walk(A,R1,R2),inRoom(A,R1),T) :-
  R1!=R2, agent(A), room(R1), room(R2), time(T).

terminates(unlock(A, R), locked(R), T) :-
    holdsAt(holding(A, key), T), room(R).

% An agent can not be in two different rooms at the same time
:- R1!=R2, holdsAt(inRoom(O,R1),T), holdsAt(inRoom(O,R2),T),
  object(O), room(R1), room(R2), time(T).

% An agent can pick up an object only if they are in the same room as the object
% When the agent picks up an object, they start holding it
initiates(pickUp(A,O),holding(A,O),T) :-
  holdsAt(inRoom(A,R),T), holdsAt(inRoom(O,R),T),
  agent(A), object(O), room(R), time(T).

% When an agent lets go of an object, they stop holding it
terminates(letGoOf(A,O),holding(A,O),T) :-
  holdsAt(holding(A,O),T), agent(A), object(O), time(T).

% When an agent holding an objects move to a new room, the objects moves with them
initiates(E,inRoom(O,R),T) :-
  initiates(E,inRoom(A,R),T), holdsAt(holding(A,O), T).
terminates(E,inRoom(O,R),T) :-
  terminates(E,inRoom(A,R),T), holdsAt(holding(A,O), T).

% An agent can not pick up or let of of another agent.
:- agent(A1), agent(A2), happens(pickUp(A1, A2), _).
:- agent(A1), agent(A2), happens(letGoOf(A1, A2), _).
% An agent cannot unlock a door if they are not holding a key.
:- happens(unlock(A, R), T), not holdsAt(holding(A, key), T).

% Problem instance
agent(john).
object(book).
object(key).
object(A) :- agent(A).
room(livingRoom).
room(kitchen).

% Initial conditions
holdsAt(inRoom(john,kitchen),0).
holdsAt(inRoom(book,livingRoom),0).
holdsAt(inRoom(key,kitchen),0).

:- holdsAt(holding(john,book),0).
:- holdsAt(holding(john,key),0).
:- holdsAt(holding(A,A),T), agent(A).
holdsAt(locked(livingRoom), 0).

% Goal
goal :- holdsAt(inRoom(book, kitchen), maxtime), holdsAt(inRoom(john, livingRoom), maxtime).
:- not goal.

% Choice rule for our agent
0 { happens(E, T) : event(E) } 1 :- time(T).

eventCount(N) :- N = #count { E,T : happens(E, T) }.
#minimize { N : eventCount(N) }.
