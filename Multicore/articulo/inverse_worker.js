'use strict';

var start, end, size;

function invert(matrix, identity) {
  var result = [];
  var index = [];

  // Transform the matrix into an upper triangle
  gauss(size, matrix, index);

  // Update the identity matrix with the ratios stored
  for (var i = 0; i < size - 1; i++)
    for (var j = i + 1; j < size; j++)
      for (var k = 0; k < size; k++)
        identity[index[j]][k] -= matrix[index[j]][i] * identity[index[i]][k];

  // Backward substitution
  for (var i = 0; i < size; i++) {
    if (!result[size - 1]) {
      result[size - 1] = [];
    }
    result[size - 1][i] = identity[index[size - 1]][i] / 
      matrix[index[size - 1]][size - 1];
    for (var j = size - 2; j >= 0; j--) {
      if (!result[j]) {
        result[j] = [];
      }
      result[j][i] = identity[index[j]][i];
      for (var k = j + 1; k < size; k++) {
        result[j][i] -= matrix[index[j]][k] * result[k][i];
      }
      result[j][i] /= matrix[index[j]][j];
    }
  }
  return result;
}

// Gauss elimination. index[] stores pivots
function gauss(matrix, index) {
  var c = [];
  for (var i = 0; i < size; i++) index[i] = i;

  // Get ratios
  for (var i = 0; i < size; i++) {
    var min = 0, curr = 0;
    for (var j = 0; j < size; j++) {
      curr = Math.abs(matrix[i][j]);
      if (curr > min) min = curr;
    }
    c[i] = min;
  }

  // Search the pivoting element from each column
  var k = 0;
  for (var j = 0; j < size - 1; j++) {
    var pi, min = 0;
    for (var i = j; i < size; i++) {
      pi = Math.abs(matrix[index[i]][j]);
      pi /= c[index[i]];
      if (pi > min) {
        min = pi;
        k = i;
      }
    }

    // Pivot rows
    var tempIndex = index[j];
    index[j] = index[k];
    index[k] = tempIndex;
    for (var i = j + 1; i < size; i++) {
      var pj = matrix[index[i]][j] / matrix[index[j]][j];
      // Record pivoting ratios below the diagonal
      matrix[index[i]][j] = pj;
      // Modify other elements accordingly
      for (var l = j + 1; l < size; l++) {
        matrix[index[i]][l] -= pj * matrix[index[j]][l];
      }
    }
  }
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
