var main = require('./output/Main/index.js').main;

(function() {
  var container = document.getElementById('app');
  container.appendChild(main.rootNode);
})();
