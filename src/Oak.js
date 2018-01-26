var h = require('virtual-dom/h');

exports.nativeText = function(text) {
  return text;
};

// foreign import bindD :: forall a b. DOM a -> (a -> DOM b) -> DOM b
exports.bindD = function(virtualdom) {
  return function(callback) {
    // wire up event handlers to call the callback
  };
};

// foreign import pureD :: forall a. a -> DOM a
exports.pureD = function(x) {
  console.log('PUREPUREPUREPUREPURPERU');
  return x;
};

// foreign import renderN :: forall msg. String -> Array (DOM msg) -> DOM msg
exports.renderN = function(name) {
  return function(children) {
    return h(name, {}, children);
  };
};
