% Authors:
%   A01370815 Diego Galindez Barreda
%   A01165988 Eduardo Azuri Gaytan Martinez 

-module(inverse).
-compile(sequential/1, concurrent/1).

sequential(L) ->
    L.

concurrent(L) ->
    L.

gauss_jordan(L, I) ->
 case I =:= length(L) of
    true -> L,
    _ ->
    let
    (irow,Ap) = head_rest(A);
    val = irow[i];
    irow = {v/val : v in irow};
    Ap = {let scale = jrow[i]
          in {v - scale*x : x in irow; v in jrow}
          : jrow in Ap}
in Gauss_Jordan(Ap++[irow],i+1) $

matrix_inverse(L) ->
    N = length(L),
    % Pad the matrix with the identity matrix (i.e. A ++ I) %
    Ap = {row ++ rep(dist(0.,n),1.0,i):
     row in A; i in [0:n]};

    % Run Gauss-Jordan elimination on padded matrix %
    Ap = Gauss_Jordan(Ap,0);

  % Drop the identity matrix at the front %
  in {drop(row,n) : row in Ap} $

A = [[1.0, 2.0, 1.0], [2.0, 1.0, 1.0], [1.0, 1.0, 2.0]];
AI = matrix_inverse(A);
matrix_inverse(AI);
