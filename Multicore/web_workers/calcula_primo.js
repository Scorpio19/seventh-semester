'use strict';

var n = 1;

busca: while (true) {
  n += 1;
  for (var i = 2; i <= Math.sqrt(n); i++) {
    if (n % i == 0) {
      continue busca;
    }
  }
  postMessage(n);
}