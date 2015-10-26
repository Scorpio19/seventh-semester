'use strict';

$(function () {
  var MAXN = 3; //1000;
  var workersFinished = 0;
  var numWorkers = 4;

  var start = 0;
  var end = MAXN; // numWorkers;
  var identity = [];

  var matrix = [
    [1, 1, 2],
    [1, 2, 1],
    [1, 1, 1]
  ];

  for (var i = 0; i < MAXN; i++) {
    identity[i] = [];
    for (var j = 0; j < MAXN; j++) {
      identity[i][j] = 0;
      if (i === j) {
        identity[i][j] = 1;
      }
    }
  }

  var startTime = performance.now();
  //for (var i = 1; i <= numWorkers; i++) {
    //end *= i;
    var w = new Worker('inverse_worker.js');
    w.postMessage({size: MAXN, matrix: matrix, identity: identity, start: start, end: end});
    //start = end;

    w.onmessage = function (event) {
      workersFinished++;
      //if (workersFinished === numWorkers) {
        var endTime = performance.now();
        $('#parallel').html((endTime - startTime) / 1000);
      //}
    };
  //}
});

