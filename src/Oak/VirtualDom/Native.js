var h = require('virtual-dom/h');
var diff = require('virtual-dom/diff');
var patch = require('virtual-dom/patch');
var createElement = require('virtual-dom/create-element');

// foreign import createRootNode :: forall e.
//   Tree
//     -> Eff ( createRootNode :: NODE | e ) Node
exports.createRootNode = function(tree) {
  return function() {
    var root = createElement(tree);
    return root;
  };
};


// foreign import textN :: forall e.
//   String
//     -> Eff e Tree
exports.textN = function(str) {
  return function() {
    return str;
  };
};

// foreign import renderN :: forall msg h e model.
//   (msg -> Eff ( st :: ST h | e ) (Runtime model msg))
//     -> String
//     -> NativeAttrs
//     -> Eff ( st :: ST h | e ) (Array Tree)
//     -> Eff ( st :: ST h | e ) Tree
exports.renderN = function(tagName) {
  return function(attrs) {
    return function(childrenEff) {
      return function() {
        var children = childrenEff();
        return h(tagName, attrs, children);
      };
    };
  };
};

// foreign import patchN :: forall e h.
//   Tree
//     -> Tree
//     -> Maybe Node
//     -> Eff ( st :: ST h | e ) Node
exports.patchN = function(newTree) {
  return function(oldTree) {
    return function(rootNode) {
      return function() {
        var patches = diff(oldTree, newTree);
        var newRoot = patch(rootNode, patches);
        return newRoot;
      };
    };
  };
};


// foreign import concatHandlerFun :: forall msg eff event.
//   (msg -> eff)
//     -> String
//     -> (event -> eff)
//     -> NativeAttrs
//     -> NativeAttrs
exports.concatHandlerFun = function(name) {
  return function(msgHandler) {
    return function(rest) {
      var result = Object.assign({}, rest);
      result[name] = msgHandler();
      return result;
    };
  };
};

// foreign import emptyAttrsN :: NativeAttrs
exports.emptyAttrsN = function() {
  return {};
};
