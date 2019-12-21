exports.getElementByIdImpl = function(id) {
  return function() {
    var container = document.getElementById(id);
    if (container == null) {
      throw new Error("Unable to find element with ID: " + id);
    }

    return container;
  };
};

exports.appendChildNodeImpl = function(container) {
  return function(rootNodes) {
    return function() {
      for (var i in rootNodes) {
        container.appendChild(rootNodes[i]);
      }
    };
  };
};
