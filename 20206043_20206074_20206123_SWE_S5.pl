:- [data].

% The cut operator is not used because we need backtracking in other rules
is_friend(X, Y) :-
    friend(X, Y).
is_friend(X, Y) :-
    friend(Y, X).

my_member(X, [X | _]) :- !. % The branch below assumes X =\= Y
my_member(X, [_ | Ys]) :-
    my_member(X, Ys).

% Uses bidirectional friend relationship
friend_list(X, Acc, Xs) :-
    is_friend(X, Y),
    \+ my_member(Y, Acc),
    !, % The branch below assumes either Y is a friend or it is a member in the accumulator
    friend_list(X, [Y | Acc], Xs).
friend_list(_, Acc, Acc).
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
    !, % The branch below checks that X is not a member of Xs
    remove_duplicates(Xs, Ys).
remove_duplicates([X | Xs], [X | Ys]) :-
    \+my_member(X, Xs),
    remove_duplicates(Xs, Ys).
remove_duplicates([], []).

remove_friends_and_self(X, [Y | Ys], [Y | Zs]) :-
    \+is_friend(X, Y),
    \+(X = Y),
    !, % The branch below assumes X = Y or Y is a friend
    remove_friends_and_self(X, Ys, Zs).
remove_friends_and_self(X, [_ | Ys], Zs) :-
    !, % The branch below is the base case
    remove_friends_and_self(X, Ys, Zs).
remove_friends_and_self(_, [], []).

count_occurrences(_, [], Acc, Acc).
count_occurrences(X, [X | Xs], Acc, N) :-
    Accp is Acc + 1,
    count_occurrences(X, Xs, Accp, N).
count_occurrences(X, [_ | Xs], Acc, N) :-
    count_occurrences(X, Xs, Acc, N).
count_occurrences(X, Xs, N) :- count_occurrences(X, Xs, 0, N).

friends_of_friends(X, Ns) :-
    friend_list(X, Xs),
    concatenate_friend_lists(Xs, Ys),
    my_flatten(Ys, Zs),
    remove_friends_and_self(X, Zs, Ns).

people_you_may_know(X, N, Y) :-
    friends_of_friends(X, Xs),
    count_occurrences(Y, Xs, N), % Will get the y if it occurs >= N
    !. % The requirements state that only ONE should be retrieved

people_you_may_know_list(X, Xs) :-
    friends_of_friends(X, Ys),
    remove_duplicates(Ys, Xs).

indirect_applicable(X, Acc, Y) :-
    \+my_member(Y, Acc),
    \+(is_friend(X, Y)),
    \+(X=Y),
    \+people_you_may_know(X, Y).

people_you_may_know_indirect(X, Acc, Y) :-
    is_friend(X, Z),
    is_friend(Z, W),
    is_friend(W, Y),
    indirect_applicable(X, Acc, Y).

people_you_may_know_indirect(X, Acc, Y) :-
    is_friend(X, Z),
    is_friend(Z, W),
    people_you_may_know(W, Y),
    indirect_applicable(X, Acc, Y).

people_you_may_know_indirect(X, Acc, Y) :-
    is_friend(X, Z),
    is_friend(Z, W),
    indirect_applicable(X, Acc, Y),
    people_you_may_know_indirect(W, [Y | Acc], Y).

people_you_may_know_indirect(X, Y) :- people_you_may_know_indirect(X, [], Y).
