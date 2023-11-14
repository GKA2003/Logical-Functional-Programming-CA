main :-
  generator3(N), tester3(N), write(N).


generator3(N) :-
    between(32, 1000, X), % X^2 1000-1mil
    N is X * X.
    
all_digits_diff(N) :-
    number_chars(N, XS),
    sort(XS, Y),
    length(XS, W),
    length(Y, Z),
    W == Z.

last_digit_equal_num_digits(N) :-
    number_chars(N, XS),
    length(XS, W),
    last_num(XS, Y),
    number_chars(S, [Y]),
    S == W.
last_num([Y], Y).
last_num([_|T], Y) :-
    last_num(T, Y).

contains_zero(N) :-
    number_chars(N, E),
    member_list('0', E).
member_list(E, [E|_]).
member_list(E, [_|XS]) :-
    member_list(E, XS).

last_but_one_odd(N) :-
    number_chars(N, XS),
    second_last_num(XS, W),
    number_chars(Y, [W]),
    Y mod 2 =:= 1. % if remainder 1 = odd

multiples_of_first_digit(N) :-
    number_chars(N, XS),
    XS = [Y|W],
    number_chars(X1, [Y]),
    get_digits(W, [X2, X3, X4]),
    valid_multiples(X1, [X2, X3, X4]).
get_digits(XS, [X2, X3, X4]) :-
    get_second_num(XS, X2),
    get_third_num(XS, X3),
    get_second_last_num(XS, X4).
valid_multiples(_, []).
valid_multiples(X1, [X|T]) :-
    (X \= 0; X1 =:= 0), % Digit not 0, or 1st digit is 0
    0 is X mod X1,
    valid_multiples(X1, T).

get_second_num([X|_], Y) :-
    number_chars(Y, [X]).
get_third_num([_,X|_], Y) :-
    number_chars(Y, [X]).
get_second_last_num(X, Y) :-
    second_last_num(X, W),
    number_chars(Y, [W]).
    
second_last_num([X,_], X).
second_last_num([_|XS], X) :-
    second_last_num(XS, X).

tester3(N) :-
    all_digits_diff(N),
    last_digit_equal_num_digits(N),
    contains_zero(N),
    last_but_one_odd(N),
    multiples_of_first_digit(N).
