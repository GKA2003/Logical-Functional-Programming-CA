main :-
    generator4(XS), tester4(XS), write(XS).


generator4(XS) :-
    numlist(0, 9, X),
    permutation(X, W),
    runs(W, XS).

runs([], []).
runs(X, [Y|YS]) :-
    between(1, 4, W),
    length(Y, W),
    append(Y, T, X),
    Y = [H|_], H \= 0, % Ensure the first digit of the run is not zero
    run_to_num(Y, Num),
    prime(Num),
    runs(T, YS).

prime(2) :-
    true.
prime(N) :-
    N >= 2, \+ factorisable(2, N).
factorisable(F, N) :-
    0 is N mod F.
factorisable(F, N) :-
    F1 is F + 1,
    F1 =< sqrt(N),
    factorisable(F1, N).

run_to_num(X, Y) :-
    X \= [],
    maplist(number_string, X, Strings), %Convert each number to a string
    atomic_list_concat(Strings, '', Atom), %Concatenate all strings
    atom_number(Atom, Y). %Convert the concatenated atom to a number


tester4(XS) :-
    maplist(run_to_num, XS, N),
    delete_min(N, NS),
    sort(0, @>=, NS, W),
    run_to_num(W, H),
    number_chars(H, X),
    runs_check(X).

runs_check([]).
runs_check(XS) :-
    sublist_run(XS, X),
    number_chars(N, X),
    cube(N),
    append(X, NS, XS),
    runs_check(NS).

delete_min(X, XS) :-
    min_list(X, Min),
    select(Min, X, XS).

sublist_run(X, W) :-
    append(W, _, X),
    length(W, L),
    L >= 1, L =< 4.

cube(N) :-
    integer(N),
    N >= 0,
    find_cube_root(N, 0).

find_cube_root(N, X) :-
    W is X * X * X,
    (W = N; (W < N, XS is X + 1, find_cube_root(N, XS))).
