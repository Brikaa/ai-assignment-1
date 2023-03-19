:- [data].

% The cut operator is not used to generate all lists of friends in queries
is_friend(X, Y) :-
    friend(X, Y).
is_friend(X, Y) :-
    friend(Y, X).

my_member(X, [X | _]) :- !.
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
    !,
    friend_list(X, [Y | Acc], Xs).

friend_list(X, Xs) :- friend_list(X, [], Xs), !.

count([], Acc, Acc).
count([_ | Xs], Acc, N) :-
    Accp is Acc + 1,
    count(Xs, Accp, N).
count(Xs, N) :- !, count(Xs, 0, N).

friend_list_count(X, N) :-
    friend_list(X, Ys),
    count(Ys, Np),
    N is Np.

people_you_may_know(X, Y) :-
    is_friend(X, Z),
    is_friend(Z, Y),
    \+(X=Y),
    \+is_friend(X, Y).

count_commons(_, [], Acc, Acc) :- !.
count_commons(Xs, [Y | Ys], Acc, N) :-
    my_member(Y, Xs),
    !,
    Accp is Acc + 1,
    count_commons(Xs, Ys, Accp, N).
count_commons(Xs, [Y | Ys], Acc, N) :-
    \+my_member(Y, Xs),
    !,
    count_commons(Xs, Ys, Acc, N).
count_commons(Xs, Ys, N) :- !, count_commons(Xs, Ys, 0, N).

% people_you_may_know(X, N, Y) :-
%     friend_list(X, Xs),
%     friend_list(Y, Ys),
%     count_commons(Xs, Ys, Np),
%     N is Np.
