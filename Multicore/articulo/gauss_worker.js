onmessage = function(event) {
  var start = event.data.start;
  var end = event.data.end;
  var irow = event.data.irow;
  var val = event.data.val;
  var A = event.data.A;

  if (!A) {
    for (var i = start; i < end; i++) {
      irow[i] /= val;
    }

    postMessage({start: start, end: end, irow: irow});
  } else {
    var i = event.data.i;
    var size = event.data.size;
    for (var j = start; j < end; j++) {
      var jrow = A[j];
      var scale = jrow[i];
      for (var k = 0; k < size * 2; k++) {
        jrow[k] -= (irow[k] * scale * 1.0);
      }
    }
    postMessage({start: start, end: end, jrow: A});
  }
}
