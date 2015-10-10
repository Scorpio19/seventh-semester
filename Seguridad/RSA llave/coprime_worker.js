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

function modinv(a,m) {
  var v = 1;
  var d = a;
  var u = (a == 1);
  var t = 1-u;
  if (t == 1) {
    var c = m % a;
    u = Math.floor(m/a);
    while (c != 1 && t == 1) {
      var q = Math.floor(d/c);
      d = d % c;
      v = v + q*u;
      t = (d != 1);
      if (t == 1) {
        q = Math.floor(c/d);
        c = c % d;
        u = u + q*v;
      }
    }
    u = v*(1 - t) + t*(m - u);
  }
  return u;
}

onmessage = function(event) {
  var start = event.data.start;
  var end = event.data.end;

  var nums = "";

  for (var i = start; i < end; i++) {
    if (isCoprime(i, 3220) && modinv(i, 3220) === 1019) {
      nums += i + ",";
    }
  }

  postMessage(nums);
}
