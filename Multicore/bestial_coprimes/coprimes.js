'use strict';

$(function () {
  var workersFinished = 0;
  var numWorkers = 4;

  var from = 0;
  var to = 100000000 / numWorkers;

  var sum = 0;

  var startTime = performance.now();

  for (var i = 1; i <= numWorkers; i++) {
    var w = new Worker('coprime_worker.js');
    w.postMessage({start: from, end: to * i});

    from = to * i;

    w.onmessage = function (event) {
      workersFinished++;
      sum += event.data;
      if (workersFinished === numWorkers) {
        var endTime = performance.now();
        $('#parallel').html(sum + '<br />Time: ' + (endTime - startTime) / 1000);
      }
    };
  }

  startTime = performance.now();

  var w = new Worker('coprime_worker.js');
  w.postMessage({start: 0, end: to * numWorkers});

  from = to * i;

  w.onmessage = function (event) {
    var endTime = performance.now();
    $('#sequential').html(sum + '<br />Time: ' + (endTime - startTime) / 1000);
  };

});
