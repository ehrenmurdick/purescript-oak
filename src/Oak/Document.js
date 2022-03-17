exports.getElementByIdImpl = function (id) {
  return function () {
    var container = document.getElementById(id);
    if (container == null) {
      throw new Error("Unable to find element with ID: " + id);
    }

    return container;
  };
};

exports.appendChildNodeImpl = function (container) {
  return function (rootNode) {
    return function () {
      console.log("container", container)
      console.log("rootNode", rootNode)
      container.appendChild(rootNode);
    };
  };
};

exports.onDocumentReadyImpl = function (eff) {
  return function () {
    document.addEventListener("DOMContentLoaded", eff);
  };
};
