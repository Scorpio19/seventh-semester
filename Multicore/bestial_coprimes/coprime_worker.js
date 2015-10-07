function gcd(a, b) {
  var c;

  if (a > b) {
    c = a;
    a = b;
    b = c;
  }

  while (a !== 0) {
    c = a;
    a = b % a;
    b = c;
  }

  return b;
}

function isCoprime(a, b) {
  return gcd(a, b) === 1;

}

onmessage = function(event) {
  var start = event.data.start;
  var end = event.data.end;

  var sum = 0;

  for (var i = start; i < end; i++) {
    if (isCoprime(i, 666)) {
      sum += i;
    }
  }

  postMessage(sum);
}
