'use strict';

var MAXN = 120;
var numWorkers = 4;
var startTime;

var original = [];
original.length = MAXN;

var padWorkers = [];
padWorkers.length = numWorkers;

var gaussWorkers = [];
gaussWorkers.length = numWorkers;

function scaleJordan(A, i, irow, j) {
  if (j >= MAXN - 1) {
    A.push(irow);
    gaussJordan(A, i + 1);
    return;
  }

  var jrow = A[j];
  var scale = jrow[i];

  var workersFinished = 0;
  var start = 0;
  var chunkSize = MAXN * 2 / numWorkers;
  var end;
  for (var k = 0; k < numWorkers; k++) {
    end = start + chunkSize;
    gaussWorkers[k].postMessage({start: start, end: end, irow: irow, jrow: jrow, scale: scale});
    start += chunkSize;

    gaussWorkers[k].onmessage = function (event) {
      workersFinished++;
      for (var l = event.data.start; l < event.data.end; l++) {
        jrow[l] = event.data.jrow[l];
      }
      if (workersFinished === numWorkers) {
        scaleJordan(A, i, irow, j + 1);
      }
    };
  }
}

function gaussJordan(A, i) {
  if (i === A.length) {
    var endTime = performance.now();
    if (numWorkers > 1) {
      $("#parallel").html((endTime - startTime) / 1000);
      printMatrix(A);

      numWorkers = 1;
      padMatrix(original);
    } else {
      $("#sequential").html((endTime - startTime) / 1000);
      printMatrix(A);
    }
    return;
  }

  var irow = A.shift();
  var val = irow[i];

  var workersFinished = 0;
  var start = 0;
  var chunkSize = MAXN * 2 / numWorkers;
  var end;
  for (var j = 0; j < numWorkers; j++) {
    end = start + chunkSize;
    gaussWorkers[j].postMessage({start: start, end: end, irow: irow, val: val});
    start += chunkSize;
    
    gaussWorkers[j].onmessage = function (event) {
      workersFinished++;
      for (var k = event.data.start; k < event.data.end; k++) {
        irow[k] = event.data.irow[k];
      }
      if (workersFinished === numWorkers) {
          scaleJordan(A, i, irow, 0);
      }
    };
  }
}

function padMatrix(matrix) {
  startTime = performance.now();
  var workersFinished = 0;
  var start = 0;
  var chunkSize = MAXN / numWorkers;
  var end;

  for (var i = 0; i < numWorkers; i++) {
    end = start + chunkSize;
    padWorkers[i].postMessage({start: start, end: end, matrix: matrix, size: MAXN});
    start += chunkSize;

    padWorkers[i].onmessage = function (event) {
      workersFinished++;
      for (var j = event.data.start; j < event.data.end; j++) {
        matrix[j] = event.data.padded[j];
      }
      if (workersFinished === numWorkers) {
        gaussJordan(matrix, 0);
      }
    };
  }
}

function printMatrix(matrix) {
  var res = "";
  for (var i = 0; i < matrix.length; i++) {
    for (var j = matrix.length; j < matrix.length * 2; j++) {
      res += matrix[i][j] + ", ";
    }
    res += "\n";
  }
  console.log(res);
}

$(function () {
  /*
  original = [
    [1.0, 1.0, 2.0, 1.0],
    [1.0, 2.0, 1.0, 2.0],
    [1.0, 1.0, 1.0, 3.0],
    [2.0, 3.0, 1.0, 3.0]];
  MAXN = 4;
  //*/

  //*
  var randomNum;
  for (var i = 0; i < MAXN; i++) {
    original[i] = [];
    original[i].length = MAXN;
    for (var j = 0; j < MAXN; j++) {
      randomNum = 1.0 + (Math.random() * MAXN);
      original[i][j] = randomNum;
    }
  }
  //*/

  for (var i = 0; i < numWorkers; i++) {
    padWorkers[i] = new Worker('pad_worker.js');
    gaussWorkers[i] = new Worker('gauss_worker.js');
  }

  padMatrix(original.slice());
});
