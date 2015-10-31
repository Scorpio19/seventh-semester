-module(inverse).
% TODO: Proper exports
-compile(export_all).

%start Sequential padding

sequential_row(1) -> [0];
sequential_row(I) -> [0 | sequential_row(I - 1)].

sequential_identity(S, S) -> [];
sequential_identity(S, R) -> 
    {A, B} = lists:split(R, sequential_row(S - 1)),
    I = [A ++ [1] ++ B],
    I ++ sequential_identity(S, R + 1).

sequential_pad(A) ->
    I = sequential_identity(length(A), 0),
    sequential_pad(A, I, length(A)).

sequential_pad(_, _, 0) -> [];

sequential_pad(A, I, R) ->
    Row = [lists:nth(R, A) ++ lists:nth(R, I)],
    sequential_pad(A, I, R - 1) ++ Row.

%end Sequential padding

%start Sequential GaussJordan

sequential_scale([], _, _) -> [];

sequential_scale([V | J], [X | I], S) ->
    R = V - (S * X),
    [R] ++ sequential_scale(J, I, S).

sequential_drop_identity(A) ->
    N = length(A),
    lists:map(fun(R) ->
                      {_, X} = lists:split(N, R),
                      X
              end, A).

sequential_gauss_jordan(A, I) ->
    case (I > length(A)) of
        true -> sequential_drop_identity(A);
        _ ->
            [Ir | T] = A,
            V = lists:nth(I, Ir),
            Irow = lists:map(fun(X) -> X / V end, Ir),
            Ap = lists:map(fun(Jrow) -> sequential_scale(Jrow, Irow, lists:nth(I, Jrow)) end, T),
            sequential_gauss_jordan(Ap ++ [Irow], I + 1)
    end.

sequential_inverse(A) ->
    Ap = sequential_pad(A),
    sequential_gauss_jordan(Ap, 1).

%end Sequential GaussJordan

concurrent(L) ->
    L.
