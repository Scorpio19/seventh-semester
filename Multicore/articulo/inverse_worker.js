'use strict';

var start, end, size;

function invert(matrix, identity) {
  var result = [];
  var index = [];

  // Transform the matrix into an upper triangle
  gauss(matrix, index);

  // Update the identity matrix with the ratios stored
  for (var i = start; i < end - 1; i++)
    for (var j = i + 1; j < end; j++)
      for (var k = start; k < end; k++)
        identity[index[j]][k] -= matrix[index[j]][i] * identity[index[i]][k];

  // Backward substitution
  for (var i = start; i < end; i++) {
    if (!result[size - 1]) {
      result[size - 1] = [];
    }
    result[size - 1][i] = identity[index[size - 1]][i] / matrix[index[size - 1]][size - 1];
    for (var j = end - 2; j >= 0; j--) {
      if (!result[j]) {
        result[j] = [];
      }
      result[j][i] = identity[index[j]][i];
      for (var k = j + 1; k < end; k++) {
        result[j][i] -= matrix[index[j]][k] * result[k][i];
      }
      result[j][i] /= matrix[index[j]][j];
    }
  }
  return result;
}

onmessage = function (event) {
  var matrix = event.data.matrix;
  var identity = event.data.identity;
  size = event.data.size;
  start = event.data.start;
  end = event.data.end;
  var result = invert(matrix, identity);

  postMessage(result);
}
