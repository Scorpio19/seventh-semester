onmessage = function(event) {
  var start = event.data.start;
  var end = event.data.end;
  var size = event.data.size;
  var matrix = event.data.matrix;
  var index = event.data.index;
  var scales = event.data.scales;
  var p, maxI = 0, max = 0;

  if (start >= event.data.size) {
    postMessage({max: -Infinity});
    return;
  }

  for (var i = start; i < end; i++) {
    p = Math.abs(matrix[index[i]][start]);
    p /= scales[index[i]];
    if (p > max) {
      max = p;
      maxI = i;
    }
  }
  postMessage({max: maxI});
}
