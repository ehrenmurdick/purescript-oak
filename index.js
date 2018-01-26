var app = require('./output/Main/index.js').main;
var oak = require('./output/Oak/index.js');
var createElement = require('virtual-dom/create-element');
var h = require('virtual-dom/h');

(function() {
  var container = document.getElementById('app');
  var rootNode = createElement(oak.renderHTML(app.value0.view(app.value0.model)));
  oak.runApp(app)(rootNode);
  console.log(rootNode);
  var container = document.getElementById('app');
  container.appendChild(rootNode);
})();
