-module(ejemplos).
-compile(export_all).

fact(0) -> 1;
fact(N) when N > 0 ->
    N * fact(N - 1).

sqr([]) -> [];
sqr([H|T]) -> [H * H | sqr(T)].

dup([]) -> [];
dup([H|T]) -> [H, H | dup(T)].

pow(_N, 0) -> 1;
pow(N, P) -> N * pow(N, P - 1).

log2(1) -> 0;
log2(N) -> 1 + log2(N div 2).

cuantos(_X, []) -> 0;
cuantos(X, [X | T]) -> 1 + cuantos(X, T);
cuantos(X, [H | T]) when is_list(H) -> cuantos(X, H) + cuantos(X, T);
cuantos(X, [_H | T]) -> cuantos(X, T).
