onmessage = function(event) {
  var start = event.data.start;
  var end = event.data.end;
  var length = event.data.length;
  var line = [];
  for (var i = start; i < end; i++) {
    line[i] = [];
    for (var j = 0; j < length; j++) {
      line[i][j] = 0;
      if (i === j) {
        line[i][j] = 1;
      }
    }
  }

  postMessage(line);
}
