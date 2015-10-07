'use strict';

onmessage = function (event) {
  var num_rects = event.data.num_rects;
  var start = event.data.start;
  var end = event.data.end;
  var sum = 0;
  var width = 1 / num_rects;
  for (var i = start; i < end; i++) {
    var mid = (i + 0.5) * width;
    var height = 4 / (1 + mid * mid);
    sum += height;
  }
  postMessage(sum);
}
