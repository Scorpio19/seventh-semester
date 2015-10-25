'use strict';

$(function () {
  var time_start = performance.now(); // milliseconds
  var num_rects = 10000000000;
  var width = 1 / num_rects;
  var num_workers = 4;
  var tam_cacho = num_rects / num_workers;
  var sum = 0;
  var workers_finalizados = 0;
  
  for (var i = 0; i < num_workers; i++) {
    var w = new Worker('pi_worker.js');
    w.postMessage({ num_rects: num_rects,
                    start: i * tam_cacho,
                    end: (i + 1) * tam_cacho });
    w.onmessage = function (event) {
      workers_finalizados++;
      sum += event.data;
      if (workers_finalizados === num_workers) {
        var area = sum * width;
        var time_end = performance.now();
        $('#resultado').html(
          'Valor de pi = ' + area + '<br />' +
          'tiempo = ' + (time_end - time_start) / 1000          
        );
      }
    };
  }
});
