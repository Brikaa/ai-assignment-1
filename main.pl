:- [data].

is_friend(X, Y) :-
    friend(X, Y).
is_friend(X, Y) :-
    friend(Y, X).

my_member(X, [X | _]).
my_member(X, [_ | Ys]) :-
    my_member(X, Ys).

friendList(X, Acc, Acc) :-
    \+ (
        is_friend(X, Y),
        \+ my_member(Y,Acc)
    ).

friendList(X, Acc, Xs) :-
    is_friend(X, Y),
    \+ my_member(Y, Acc),
    !,
    friendList(X, [Y | Acc], Xs).

friendList(X, Xs) :- friendList(X, [], Xs).
