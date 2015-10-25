'use strict';

$(function () {
  var MAXN = 1000;
  var workersFinished = 0;
  var numWorkers = 4;

  var start = 0;
  var end = MAXN / numWorkers;
  var identity = [];

  var startTime = performance.now();
  for (var i = 0; i < numWorkers; i++) {
    var w = new Worker('identity_worker.js');
    w.postMessage({start: start, end: end});

    w.onmessage = function (event) {
      workersFinished++;
      identity[i] = event.data;
      if (workersFinished === numWorkers) {
        var endTime = performance.now();
        console.log(identity);
        $('#parallel').html((endTime - startTime) / 1000);
      }
    };
  }

  startTime = performance.now();

  var w = new Worker('identity_worker.js');
  w.postMessage({start: 0, end: to * numWorkers});

  from = to * i;

  w.onmessage = function (event) {
    var endTime = performance.now();
    $('#sequential').html((endTime - startTime) / 1000);
  };

});

