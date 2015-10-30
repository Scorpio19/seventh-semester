onmessage = function(event) {
  var start = event.data.start;
  var end = event.data.end;
  var irow = event.data.irow;
  var jrow = event.data.jrow;
  var scale = event.data.scale;
  var val = event.data.val;

  if (!jrow) {
    for (var i = start; i < end; i++) {
      irow[i] /= val;
    }

    postMessage({start: start, end: end, irow: irow});
  } else {
    for (var i = start; i < end; i++) {
      jrow[i] -= (irow[i] * scale * 1.0);
    }
    postMessage({start: start, end: end, jrow: jrow});
  }
}
