:- [data].

% The cut operator is not used to generate all lists of friends in queries
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

count([], Acc, Acc).
count([_ | Xs], Acc, N) :-
    Accp is Acc + 1,
    count(Xs, Accp, N).
count(Xs, N) :- count(Xs, 0, N).

friendListCount(X, N) :-
    friendList(X, Ys),
    count(Ys, Np),
    N is Np.


peopleYouMayKnow(X, Y) :-
    is_friend(X, Z),
    is_friend(Z, Y),
    \+(X=Y),
    \+is_friend(X, Y).

