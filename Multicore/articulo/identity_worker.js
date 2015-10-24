onmessage = function(event) {
  var row = event.data.row;
  var line = [];
  line[row] = 1;

  postMessage(line, row);
}
