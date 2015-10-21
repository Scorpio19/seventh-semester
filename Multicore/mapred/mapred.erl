% Authors:
%   A01370815 Diego Galindez Barreda
%   A01165988 Eduardo Azuri Gaytan Martinez 

-module(mapred).
-compile(export_all).

mas_grande(L) ->
    Lengths = dict:to_list(plists:mapreduce(fun (X) ->  {length(X), X} end, L)),
    {_, [V|_]} = lists:max(Lengths),
    V.
