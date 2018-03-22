exports.embedImpl = function(id) {
  return function(rootNode) {
    return function() {
      var container = document.getElementById(id);
      container.appendChild(rootNode);
    };
  };
};
