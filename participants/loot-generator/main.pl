item(diamond).
item(gold).
item(porkchop).
item(lapis).

value(diamond, 10).
value(gold, 7).
value(porkchop, 2).
value(lapis, 4).

count(1..10).

0 { in_chest(Item, Count) : count(Count) } 1 :- item(Item).

total_value(V) :- V = #sum { ItemValue * Count : in_chest(Item, Count), value(Item, ItemValue) }.

:- total_value(V), V < 10.
:- total_value(V), V > 69.

differentItems(I) :- I = #count { Item : in_chest(Item, _) }.

:- differentItems(I), I != 3.

#show in_chest/2.
