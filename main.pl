:- [data].

% The cut operator is not used to give all friends (regardless of direction) in queries
is_friend(X, Y) :-
    friend(X, Y).
is_friend(X, Y) :-
    friend(Y, X).

my_member(X, [X | _]).
my_member(X, [_ | Ys]) :-
    my_member(X, Ys).

% Uses bidirectional friend relationship
friend_list(X, Acc, Acc) :-
    \+ (
        is_friend(X, Y),
        \+ my_member(Y,Acc)
    ).

% Uses bidirectional friend relationship
friend_list(X, Acc, Xs) :-
    is_friend(X, Y),
    \+ my_member(Y, Acc),
    friend_list(X, [Y | Acc], Xs).

friend_list(X, Xs) :- friend_list(X, [], Xs).

count([], Acc, Acc).
count([_ | Xs], Acc, N) :-
    Accp is Acc + 1,
    count(Xs, Accp, N).
count(Xs, N) :- count(Xs, 0, N).

friend_list_count(X, N) :-
    friend_list(X, Ys),
    count(Ys, Np),
    N is Np.

people_you_may_know(X, Y) :-
    is_friend(X, Z),
    is_friend(Z, Y),
    \+(X=Y),
    \+is_friend(X, Y).

count_commons(_, [], Acc, Acc).
count_commons(Xs, [Y | Ys], Acc, N) :-
    my_member(Y, Xs),
    Accp is Acc + 1,
    count_commons(Xs, Ys, Accp, N).
count_commons(Xs, [Y | Ys], Acc, N) :-
    \+my_member(Y, Xs),
    count_commons(Xs, Ys, Acc, N).
count_commons(Xs, Ys, N) :- count_commons(Xs, Ys, 0, N).

people_you_may_know(X, N, Y) :-
    friend_list(X, Xs),
    friend_list(Y, Ys),
    count_commons(Xs, Ys, Np),
    N =< Np,
    \+(X = Y).

concatenate_friend_lists([], []).
concatenate_friend_lists([X | Xs], [Y | Ys]) :-
    friend_list(X, Y),
    concatenate_friend_lists(Xs, Ys).

my_append([], Ys, Ys).
my_append([X | Xs], Ys, [X | Zs]) :-
    my_append(Xs, Ys, Zs).

my_flatten([], []).
my_flatten([X | Xs], Ys) :-
    my_flatten(Xs, Zs),
    my_append(X, Zs, Ys).

remove_duplicates([X | Xs], Ys) :-
    my_member(X, Xs),
    remove_duplicates(Xs, Ys).
remove_duplicates([X | Xs], [X | Ys]) :-
    \+my_member(X, Xs),
    remove_duplicates(Xs, Ys).
remove_duplicates([], []).

remove_friends_and_self(X, [Y | Ys], [Y | Zs]) :-
    \+is_friend(X, Y),
    \+(X = Y),
    remove_friends_and_self(X, Ys, Zs).
remove_friends_and_self(X, [Y | Ys], Zs) :-
    (is_friend(X, Y) ; (X = Y)),
    remove_friends_and_self(X, Ys, Zs).
remove_friends_and_self(_, [], []).

people_you_may_know_list(X, Xs) :-
    friend_list(X, Ys),
    concatenate_friend_lists(Ys, Zs),
    my_flatten(Zs, Ws),
    remove_duplicates(Ws, Ps),
    remove_friends_and_self(X, Ps, Xs).

people_you_may_know_indirect(X, Acc, Y) :-
    is_friend(X, Z),
    is_friend(Z, W),
    is_friend(W, Y),
    \+my_member(Y, Acc),
    \+(is_friend(X, Y)),
    \+(X=Y),
    \+people_you_may_know(X, Y).

people_you_may_know_indirect(X, Acc, Y) :-
    is_friend(X, Z),
    is_friend(Z, W),
    \+my_member(Y, Acc),
    people_you_may_know(W, Y),
    \+(is_friend(X, Y)),
    \+(X=Y),
    \+people_you_may_know(X, Y).

people_you_may_know_indirect(X, Acc, Y) :-
    is_friend(X, Z),
    is_friend(Z, W),
    \+my_member(Y, Acc),
    people_you_may_know_indirect(W, [Y | Acc], Y),
    \+(is_friend(X, Y)),
    \+(X=Y),
    \+people_you_may_know(X, Y).

people_you_may_know_indirect(X, Y) :- people_you_may_know_indirect(X, [], Y).
