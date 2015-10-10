'use strict';

$(function () {
  var workersFinished = 0;
  var numWorkers = 4;

  var from = 0;
  var to = 100000000 / numWorkers;

  var nums = [];

  for (var i = 1; i <= numWorkers; i++) {
    var w = new Worker('coprime_worker.js');
    w.postMessage({start: from, end: to * i});

    from = to * i;

    w.onmessage = function (event) {
      workersFinished++;
      nums.push(event.data);
      if (workersFinished === numWorkers) {
        $('#parallel').html(nums.sort().reverse().join("<br />"));
      }
    };
  }
});
