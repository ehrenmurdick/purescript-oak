var app = require('./output/Main/index.js').main;
var oak = require('./output/Oak/index.js');
var createElement = require('virtual-dom/create-element');

(function() {
  var container = document.getElementById('app');
  var dom = oak.runApp(app);
  console.log(dom);
  var rootNode = createElement(dom);
  console.log(rootNode);
  var container = document.getElementById('app');
  container.appendChild(rootNode);
})();
