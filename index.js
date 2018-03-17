var app = require('./output/Main/index.js').main;
var oak = require('./output/Oak/index.js');

(function() {
  var container = document.getElementById('app');
  var rootNode = oak.runApp(app)();
  // console.log(rootNode);
  var container = document.getElementById('app');
  container.appendChild(rootNode);
})();
