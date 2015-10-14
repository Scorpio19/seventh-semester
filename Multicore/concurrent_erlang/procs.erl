% Authors:
%   A01370815 Diego Galindez Barreda
%   A01165988 Eduardo Azuri Gaytan Martinez 

-module(procs).
-compile(export_all).

factorial(N) ->
    Pid = spawn(procs, do_fact, [N]),
    Pid ! {compute, N, self()},
    receive
        {result, R} -> R
    end.

do_fact(N) ->
    receive
        {compute, N, Pid} ->
            Pid ! {result, fact_calc(N)}
    end.

fact_calc(0) -> 1;
fact_calc(N) -> N * fact_calc(N - 1).

fibo_proc() ->
    Pid = spawn(procs, do_fibo, [0]),
    Pid.

fibo_send(A, P) when is_atom(A) ->
    case is_process_alive(P) of
        true ->
            P ! {A, self()},
            receive
                {result, R} -> R;
                {killed, _} -> killed
            end;
        false ->
            killed
    end;

fibo_send(_, P) ->
    case is_process_alive(P) of
        true ->
            P ! {kill, self()},
            receive
                {killed, _} -> killed
            end;
        false ->
            killed
    end.

do_fibo(N) ->
    receive
        {recent, P}  -> P ! {result, fibo_calc(N)},
                        do_fibo(N);
        {span, P}  -> P ! {result, N},
                      do_fibo(N);
        {_, P} -> P ! {killed, N},
                  exit(killed)
    after
        1000 ->
            do_fibo(N + 1)
    end.

fibo_calc(0) -> 0;
fibo_calc(1) -> 1;
fibo_calc(N) -> fibo_calc(N - 1) + fibo_calc(N - 2).

double(M) ->
    Pid1 = spawn(procs, do_double, [1, M]),
    Pid2 = spawn(procs, do_double, [1, M]),
    io:format("Created ~w~n", [Pid1]),
    io:format("Created ~w~n", [Pid2]),
    Pid1 ! {start, Pid2},
    ok.

do_double(C, M) when C =< M ->
    receive
        {start, P} -> io:fwrite("~w received message ~w/~w from ~w.~n", [self(), C, M, P]),
                      P ! {start, self()},
                      do_double(C + 1, M)
    end;

do_double(_,_) -> io:fwrite("~w finished.~n", [self()]).

start_process([H | T]) when length(T) > 0 ->
    H ! {start, lists:nth(1, T)},
    start_process(T);

start_process(_) ->
    ok.

ring(N, M) ->
    io:format("Current process is ~w~n", [self()]),
    Pid = spawn(procs, do_ring, [1, M]),
    io:format("Created ~w~n", [Pid]),
    L = [Pid | ring(N - 1, M, self())],
    start_process(lists:reverse(L)),
    lists:nth(1, L) ! {start, lists:nth(length(L), L)}.

ring(0, _, _) -> [];

ring(N, M, _) when N > 0 ->
    Pid = spawn(procs, do_ring, [1, M]),
    io:format("Created ~w~n", [Pid]),
    L = [Pid | ring(N - 1, M, self())],
    L.


do_ring(C, M) when C > M -> 
    receive
        {start, _} -> io:fwrite("~w finished.~n", [self()])
    end;

do_ring(C, M) ->
    receive
        {start, P} -> io:fwrite("~w received message ~w/~w from ~w.~n", [self(), C, M, P]),
                      P ! {start, self()},
                      do_ring(C + 1, M)
    end.

start_star(P, [H | T]) when length(T) > 0 ->
    H ! {start, P},
    start_star(P, T);

start_star(_, _) ->
    ok.

star(N, M) ->
    io:format("Current process is ~w~n", [self()]),
    Pid = spawn(procs, do_star, [1, 1, M, N]),
    io:format("Created ~w (center)~n", [Pid]),
    L = [Pid | star(N, M, Pid)],
    start_star(Pid, lists:reverse(L)).

star(0, _, _) -> [];

star(N, M, _) when N > 0 ->
    Pid = spawn(procs, do_double, [1, M]),
    io:format("Created ~w~n", [Pid]),
    L = [Pid | star(N - 1, M, Pid)],
    L.

% Center
do_star(C, T, M, N) when T < N ->
    receive
        {start, P} -> io:fwrite("~w received message ~w/~w from ~w.~n", [self(), C, M, P]),
                      P ! {start, self()},
                      do_star(C, T + 1, M, N)
    end;

do_star(C, _T, M, N) when C < M ->
    receive
        {start, P} -> io:fwrite("~w received message ~w/~w from ~w.~n", [self(), C, M, P]),
                      P ! {start, self()},
                      do_star(C + 1,  1, M, N)
    end;

do_star(C, T, M, N) when C == M ->
    receive
        {start, P} -> io:fwrite("~w received message ~w/~w from ~w.~n", [self(), C, M, P]),
                      P ! {start, self()},
                      do_star(C + 1,  T, M, N)
    end;

do_star(_, _, _, _) -> io:fwrite("~w finished.~n", [self()]).
