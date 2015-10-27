'use strict';

var MAXN, workersFinished, numWorkers, startTime, start, end, chunkSize, identity, scales, index, matrix;

function reset() {
  MAXN = 4; //1000;
  numWorkers = 4;
  identity = [];
  scales = [];
  index = [];
  identity.length = MAXN;
  scales.length = MAXN;
  index.length = MAXN;
  matrix = [
    [1, 1, 2, 1],
    [1, 2, 1, 2],
    [1, 1, 1, 3],
    [2, 3, 1, 3]];
  init();
}

function init() {
  workersFinished = 0;
  start = 0;
  end = MAXN / numWorkers;
  chunkSize = MAXN / numWorkers;
}

$(function () {
  doParallel();
});

function doParallel() {
  reset();
  startTime = performance.now();
  for (var i = 0; i < numWorkers; i++) {
    var w = new Worker('setup_worker.js');
    w.postMessage({size: MAXN, start: start, end: end, matrix: matrix});

    w.onmessage = function (event) {
      workersFinished++;
      var rows = event.data.rows;
      var scaleRows = event.data.scaleRows;
      var currentStart = event.data.start;
      var currentEnd = event.data.end;

      for (var j = 0; j < chunkSize; j++) {
        identity[j + currentStart] = rows[j];
        scales[j + currentStart] = scaleRows[j];
      }
      if (workersFinished === numWorkers) {
        doGauss();
      }
    };
    start = end;
    end += chunkSize;
  }
}

function doSequential() {
  reset();
  startTime = performance.now();
  numWorkers = 1;
  var w = new Worker('setup_worker.js');
  w.postMessage({size: MAXN, start: 0, end: MAXN, matrix: matrix});

  w.onmessage = function (event) {
    var rows = event.data.rows;
    var scaleRows = event.data.scaleRows;

    for (var j = 0; j < MAXN; j++) {
      identity[j] = rows[j];
      scales[j] = scaleRows[j];
    }
    doGauss();
  };
}

function doGauss() {
  init();
  for (var i = 0; i < MAXN; i++) index[i] = i;
  pivot(0);
}

// Get the pivot from each column
function pivot(j) {
  if (j >= MAXN - 1) {
    updateIdentity();
    return;
  }

  var k = 0;
  workersFinished = 0;
  start = j;
  chunkSize = (MAXN - j) / numWorkers;

  for (var i = 0; i < numWorkers; i++) {
    var w = new Worker('pivot_worker.js');
    end = Math.min(Math.ceil(start + chunkSize), MAXN);
    w.postMessage({start: j, end: end, matrix: matrix, index: index, scales: scales, size: MAXN});

    w.onmessage = function (event) {
      workersFinished++;
      if (event.data.max > k) {
        k = event.data.max;
      }
      if (workersFinished === numWorkers) {
        // Pivot rows
        var tempIndex = index[j];
        index[j] = index[k];
        index[k] = tempIndex;
        for (var i = j + 1; i < MAXN; i++) {
          var pj = matrix[index[i]][j] / matrix[index[j]][j];
          // Record pivoting ratios below the diagonal
          matrix[index[i]][j] = pj;
          // Modify other elements accordingly
          for (var l = j + 1; l < MAXN; l++) {
            matrix[index[i]][l] -= pj * matrix[index[j]][l];
          }
        }
        pivot(j + 1);
      }
    };
    start = Math.ceil(start + chunkSize);
  }
}

// Update the identity matrix with the ratios stored
// TODO: Make parallel
function updateIdentity() {
  init();
  var result = [];
  result.length = MAXN;
  for (var i = 0; i < MAXN - 1; i++)
    for (var j = i + 1; j < MAXN; j++)
      // if index[i] != index[j] --> Parallelize
      // else do sequentially
      for (var k = 0; k < MAXN; k++)
        identity[index[j]][k] -= matrix[index[j]][i] * identity[index[i]][k];

  // Backward substitution
  result[MAXN - 1] = [];
  result[MAXN - 1].length = MAXN;
  for (var i = 0; i < MAXN; i++) {
    // Embarassingly parallel
    result[MAXN - 1][i] = identity[index[MAXN - 1]][i] / matrix[index[MAXN - 1]][MAXN - 1];
    for (var j = MAXN - 2; j >= 0; j--) {
      if (!result[j]) {
        result[j] = [];
        result[j].length = MAXN;
      }
      result[j][i] = identity[index[j]][i];
      for (var k = j + 1; k < MAXN; k++) {
        result[j][i] -= matrix[index[j]][k] * result[k][i];
      }
      result[j][i] /= matrix[index[j]][j];
    }
  }
  var endTime = performance.now();
  console.log(result.join("\n"));
  if (numWorkers === 1) {
    $("#sequential").html((endTime - startTime) / 1000);
  } else {
    $("#parallel").html((endTime - startTime) / 1000);
    doSequential();
  }
}
