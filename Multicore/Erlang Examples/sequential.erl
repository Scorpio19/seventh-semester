% Authors:
%   A01370815 Diego Galindez Barreda
%   A01165988 Eduardo Bazuri Gaytan Martinez 

-module(sequential).
-compile(export_all).

but_last([H|T]) when length(T) == 1 -> [H];
but_last([H|T]) -> [H] ++ but_last(T).

merge([], []) -> [];
merge(L, []) -> L;
merge([], L) -> L;
merge([H1 | T1], [H2 | T2]) when H1 < H2 -> [H1 | merge(T1, [H2 | T2])];
merge([H1 | T1], [H2 | T2]) -> [H2 | merge([H1 | T1], T2)].

insert(N, [H | T]) when N >= H -> [H] ++ [N] ++ T;
insert(N, [H | T]) -> [H] ++ insert(N, T).

sort([]) -> [];
sort([H | T]) -> sort([Y || Y <- T, Y =< H]) ++ [H] ++ sort([Y || Y <- T, Y > H]).

binary(0) -> [0];
binary(1) -> [1];
binary(N) -> binary(N div 2) ++ [N rem 2].

bcd(0) -> ["0000"];
bcd(N) when N < 10 -> [fill(integer_to_binary(N, 2))];
bcd(N) -> bcd(N div 10) ++ [fill(integer_to_binary(N rem 10, 2))].

fill(B) when byte_size(B) >= 4 -> binary_to_list(B);
fill(B) -> fill(list_to_binary([$0, B])).

prime_factors(1) -> [];
prime_factors(N) -> factors(N, primes(N)).

factors(1, _) -> [];
factors(N, [P | T]) when N rem P /= 0 -> factors(N, T);
factors(N, [P | T]) -> [P | factors(N div P, [P | T])].

primes(X) -> sieve(range(2, X)).
primes(X, Y) -> remove(primes(X), primes(Y)).

range(X, X) -> [X];
range(X, Y) -> [X | range(X + 1, Y)].

sieve([X]) -> [X];
sieve([H | T]) -> [H | sieve(remove([H * X || X <-[H | T]], T))].

remove(_, []) -> [];
remove([H | X], [H | Y]) -> remove(X, Y);
remove(X, [H | Y]) -> [H | remove(X, Y)].

compress([H | T]) when length(T) == 0 -> H;
compress([H1, H2 | T]) when H1 == H2 -> [H1 | compress(T)];
compress([H | T]) -> [H | compress(T)];
compress(H) -> H. 

encode([H | T]) when length(T) == 0 -> [H];
encode([H1, H2 | T]) when H1 /= H2 -> [H1] ++ encode([H2 | T]);
encode([H1, H2 | T]) -> [{count([H1, H2 | T]), H1}] ++ encode(T);
encode(H) -> H. 

count([H1, H2 | T]) when H1 == H2 -> 1 + count([H1 | T]);
count(_) -> 1.

decode([]) -> [];
decode([H | T]) -> expand(H) ++ decode(T).

expand({1, V}) -> [V];
expand({C, V}) -> [V | expand({C - 1, V})];
expand(V) -> [V].
