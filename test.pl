
a(1).
a(11).
a(13).

find(Acc,Acc) :- \+ (a(X), \+ memberchk(X,Acc)).
find(Acc,Output) :- a(X), \+ memberchk(X,Acc), !, find([X|Acc],Output).

find_the_as(List) :- find([], List).
