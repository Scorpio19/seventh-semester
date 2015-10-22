% Authors:
%   A01370815 Diego Galindez Barreda
%   A01165988 Eduardo Azuri Gaytan Martinez 

-module(mapred).
-compile(export_all).

primes(S, E) ->
    L = dict:to_list(plists:mapreduce(fun (X) -> { mapred:fun_primes(X), X } end, lists:seq(S, E))),
    {true, V} =  lists:max(L),
    V.

fun_primes(X) when X =< 1 -> false;

fun_primes(2) -> true;

fun_primes(X) ->
    mapred:get_primes(X, 2).

get_primes(X, M) when X < M * M -> true;

get_primes(X, M) ->
    case X rem M of
        0 -> false;
        _ -> get_primes(X, M + 1)
    end.

apocalyptic(S, E) ->
    L = dict:to_list(plists:mapreduce( fun(N) -> { mapred:fun_apocalyptic(N), N } end, lists:seq(S, E))),
    case lists:max(L) of
        {true, V} -> V;
        _ -> []
    end.

fun_apocalyptic(N) ->
    X = mapred:pow(N),
    case X rem 10 of
        6 -> fun_apocalyptic(X div 10, 1);
        _ -> fun_apocalyptic(X div 10, 0)
    end.

fun_apocalyptic(_X, N) when N >= 3 ->
    true;

fun_apocalyptic(6, 2) -> true;

fun_apocalyptic(X, _N) when X < 10 -> false;

fun_apocalyptic(X, N) ->
    case X rem 10 of
        6 -> fun_apocalyptic(X div 10, N + 1);
        _ -> fun_apocalyptic(X div 10, 0)
    end.

pow(0) -> 1;
pow(N) -> 2 * pow(N - 1).

sexy(S, E) ->
    L = dict:to_list(plists:mapreduce( fun (N) -> { fun_sexy(N), N } end, mapred:primes(S, E))),
    format_sexy(L).

format_sexy([{{X, Y, Z}, _V} | T]) ->
    [{X, Y, Z} | format_sexy(T)];

format_sexy([{{false}, _V} | T]) ->
    format_sexy(T);

format_sexy(_L) ->
    [].

fun_sexy(X) ->
    case mapred:fun_primes(X + 6) of
        true -> fun_sexy(X, X + 6);
        _ -> { false }
    end.

fun_sexy(X, Y) ->
    case mapred:fun_primes(Y + 6) of
        true -> {X, Y, Y + 6};
        _ -> { false }
    end.

phi13(S, E) ->
    L = dict:to_list(plists:mapreduce( fun (N) -> { mapred:fun_phi(mapred:pow(N)), N } end, lists:seq(S, E))),
    case lists:max(L) of
        {true, V} -> V;
        _ -> []
    end.

fun_phi(N) ->
    case sum_phi(N) rem 13 of
        0 -> true;
        _ -> false
    end.

sum_phi(N) when N < 10 -> N;

sum_phi(N) ->
    (N rem 10) + sum_phi(N div 10).
