'use strict';

var MAXN = 4; //1000;
var numWorkers = 4;

function gaussJordan(A, i) {
  if (i === A.length) {
    return A;
  }

  var irow = A.shift();
  var val = irow[i];
  for (var j = 0; j < MAXN * 2; j++) {
    irow[j] /= val;
  }

  for (var j = 0; j < MAXN - 1; j++) {
    var jrow = A[j];
    var scale = jrow[i];
    for (var k = 0; k < MAXN * 2; k++) {
      jrow[k] -= (irow[k] * scale * 1.0);
    }
  }

  A.push(irow);
  return gaussJordan(A, i+1);
}

function padMatrix(matrix) {
  for (var i = 0; i < MAXN; i++) {
    matrix[i].length = MAXN * 2;
    for (var j = MAXN; j < MAXN * 2; j++) {
      matrix[i][j] = 0;
      if (MAXN + i === j) {
        matrix[i][j] = 1;
      }
    }
  }
  return matrix;
}

function printMatrix(matrix) {
  var res = "";
  for (var i = 0; i < matrix.length; i++) {
    for (var j = matrix.length; j < matrix.length * 2; j++) {
      res += matrix[i][j] + ", ";
    }
    res += "\n";
  }
  return res;
}

$(function () {
  var matrix = [
    [1.0, 1.0, 2.0, 1.0],
    [1.0, 2.0, 1.0, 2.0],
    [1.0, 1.0, 1.0, 3.0],
    [2.0, 3.0, 1.0, 3.0]];

  var startTime = performance.now();

  matrix = padMatrix(matrix);
  matrix = gaussJordan(matrix, 0);

  var endTime = performance.now();
  console.log(printMatrix(matrix));

  $("#parallel").html((endTime - startTime) / 1000);

  numWorkers = 1;
  matrix = [
    [1.0, 1.0, 2.0, 1.0],
    [1.0, 2.0, 1.0, 2.0],
    [1.0, 1.0, 1.0, 3.0],
    [2.0, 3.0, 1.0, 3.0]];

  startTime = performance.now();

  matrix = padMatrix(matrix);
  matrix = gaussJordan(matrix, 0);

  endTime = performance.now();
  console.log(printMatrix(matrix));

  $("#sequential").html((endTime - startTime) / 1000);
});
