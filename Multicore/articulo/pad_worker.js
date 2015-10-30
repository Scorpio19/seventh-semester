onmessage = function(event) {
  var start = event.data.start;
  var end = event.data.end;
  var matrix = event.data.matrix;
  var size = event.data.size;

  for (var i = start; i < end; i++) {
    matrix[i].length = size * 2;
    for (var j = size; j < size * 2; j++) {
      matrix[i][j] = 0;
      if (size + i === j) {
        matrix[i][j] = 1;
      }
    }
  }

  postMessage({start: start, end: end, padded: matrix});
}
