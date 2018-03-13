var h = require('virtual-dom/h');
var diff = require('virtual-dom/diff');
var patch = require('virtual-dom/patch');

exports.performSideEffect = function(rootNode) {
  return function(oldTree) {
    return function(newTree) {
      return function() {
        var patches = diff(oldTree, newTree);
        patch(rootNode, patches);
        return newTree;
      }
    };
  };
};

exports.nativeText = function(text) {
  return text;
};

// foreign import renderN :: forall msg. String -> Array (DOM msg) -> DOM msg
exports.renderN = function(name) {
  return function(children) {
    return h(name, {}, children);
  };
};
