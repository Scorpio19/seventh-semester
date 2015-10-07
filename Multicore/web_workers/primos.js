'use strict';

$(function () {
  var worker = new Worker('calcula_primo.js');
  worker.onmessage = function (event) {
    $('#resultado').text(event.data);
  };
});