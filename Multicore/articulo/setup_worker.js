onmessage = function(event) {
  var start = event.data.start;
  var end = event.data.end;
  var size = event.data.size;
  var matrix = event.data.matrix;
  var rows = [];
  var scaleRows = [];

  // Get the max element from each row
  for (var i = 0; i < end - start; i++) {
    rows[i] = Array.apply(null, Array(size)).map(Number.prototype.valueOf,0);
    rows[i][start + i] = 1;
    var max = 0;
    matrix[i + start].forEach(function(curr) {
      if (Math.abs(curr) > max) max = Math.abs(curr);
    });
    scaleRows[i] = max;
  }

  postMessage({rows: rows, start: start, end: end, scaleRows: scaleRows});
}
