-module(inverse).
-compile(export_all).

%start Sequential Implementation

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

%end Sequential GaussJordan

sequential_inverse(A) ->
    Ap = sequential_pad(A),
    sequential_gauss_jordan(Ap, 1).

%end Sequential Implementation 

%start Concurrent Implementation

spawn_processes(0, _Function, _Args, _Message, _ParentId) -> ok;
spawn_processes(N, Function, Args, Message, ParentId) ->
    Pid = spawn(inverse, Function, Args),
    Pid ! {Message, ParentId},
    spawn_processes(N - 1, Function, Args, Message, ParentId).

%start Concurrent Padding

concurrent_row(1) -> [0];
concurrent_row(I) -> 
    R = [0 | sequential_row(I - 1)],
    receive
        {compute, Pid} -> Pid ! {result, R}
    end.

concurrent_identity(S, R) -> 
    spawn(inverse, spawn_processes, [S, concurrent_row, [S - 1], compute, self()]),
    concurrent_identity(S, R, spawned).

concurrent_identity(S, S, spawned) -> [];
concurrent_identity(S, R, spawned) ->
    receive
        {result, Row} ->
            {A, B} = lists:split(R, Row),
            I = [A ++ [1] ++ B],
            I ++ concurrent_identity(S, R + 1, spawned)
    end.

concurrent_pad(A) ->
    I = concurrent_identity(length(A), 0),
    sequential_pad(A, I, length(A)).

%end Concurrent Padding

%start Concurrent GaussJordan

concurrent_drop_identity(A) ->
    N = length(A),
    plists:map(fun(R) ->
                       {_, X} = lists:split(N, R),
                       X
               end, A).

concurrent_gauss_jordan(A, I) ->
    case (I > length(A)) of
        true -> concurrent_drop_identity(A);
        _ ->
            [Ir | T] = A,
            V = lists:nth(I, Ir),
            Irow = plists:map(fun(X) -> X / V end, Ir),
            Ap = plists:map(fun(Jrow) -> sequential_scale(Jrow, Irow, lists:nth(I, Jrow)) end, T),
            concurrent_gauss_jordan(Ap ++ [Irow], I + 1)
    end.

%end Concurrent GaussJordan

concurrent_inverse(A) ->
    Ap = concurrent_pad(A),
    concurrent_gauss_jordan(Ap, 1).

%end Concurrent Implementation

%start Benchmarks

generate_row(0, _) -> [];
generate_row(N, MAXN) -> [random:uniform(MAXN) | generate_row(N - 1, MAXN)].

generate_matrix(0, _) -> [];
generate_matrix(N, MAXN) -> [generate_row(MAXN, MAXN) | generate_matrix(N - 1, MAXN)].

benchmark(MAXN) ->
    Mat = generate_matrix(MAXN, MAXN), 
    %[[1.0, 1.0, 2.0, 1.0], [1.0, 2.0, 1.0, 2.0], [1.0, 1.0, 1.0, 3.0], [2.0, 3.0, 1.0, 3.0]],
    T1 = erlang:system_time(milli_seconds),
    sequential_inverse(Mat),
    T2 = erlang:system_time(milli_seconds),
    TS = (T2 - T1) / 1000,
    T3 = erlang:system_time(milli_seconds),
    concurrent_inverse(Mat),
    T4 = erlang:system_time(milli_seconds),
    TC = (T4 - T3) / 1000,
    io:format("Sequential time: ~w~n", [TS]),
    io:format("Concurrent time: ~w~n", [TC]),
    io:format("Speedup: ~w~n", [TS/TC]).

%end Benchmarks
