var h = require("virtual-dom/h");
var diff = require("virtual-dom/diff");
var patch = require("virtual-dom/patch");
var createElement = require("virtual-dom/create-element");

// foreign import createRootNodeImpl :: ∀ e.
//   Fn1 Tree (Eff ( createRootNode :: NODE | e ) Node)
exports.createRootNodeImpl = function(trees) {
  var newtrees = [];
  for (var i in trees) {
    console.log(trees[i]);
    newtrees[i] = createElement(trees[i]);
  }
  console.log(newtrees);
  return newtrees;
};

// foreign import textImpl :: ∀ e.
//   Fn1 String (Eff e Tree)
exports.textImpl = function(str) {
  return function() {
    return str;
  };
};

// foreign import renderImpl :: ∀ msg h e model.
//   Fn3
//     String
//     NativeAttrs
//     ( Effect (Array Tree) )
//     ( Effect Tree )
exports.renderImpl = function(tagName, attrs, childrenEff) {
  return function() {
    var children = childrenEff();
    return h(tagName, attrs, children);
  };
};

// foreign import patchImpl :: ∀ e h.
//   Fn3 (Array Tree) (Array Tree) (Array Node) Effect (Array Node)
exports.patchImpl = function(newTrees, oldTrees, rootNodes) {
  return function() {
    var result = [];
    for(var i in newTrees) {
      var patches = diff(oldTrees[i], newTrees[i]);
      var newRoot = patch(rootNodes[i], patches);
      result.push(newRoot);
    }
    return result;
  };
};

// foreign import concatHandlerFunImpl :: ∀ eff event.
//   Fn3 String (event -> eff) NativeAttrs NativeAttrs
exports.concatHandlerFunImpl = function(name, msgHandler, rest) {
  var result = Object.assign({}, rest);
  result[name] = function(event) {
    msgHandler(event)();
  };
  return result;
};

// foreign import concatEventTargetValueHandlerFunImpl :: ∀ eff event.
//   Fn3 String (event -> eff) NativeAttrs NativeAttrs
exports.concatEventTargetValueHandlerFunImpl = function(
  name,
  msgHandler,
  rest
) {
  var result = Object.assign({}, rest);
  result[name] = function(event) {
    msgHandler(String(event.target.value))();
  };
  return result;
};

// foreign import concatSimpleAttrImpl :: ∀ eff event.
//   Fn3 String String NativeAttrs NativeAttrs
exports.concatSimpleAttrImpl = function(name, value, rest) {
  var result = Object.assign({}, rest);
  result[name] = value;
  return result;
};

// foreign import concatBooleanAttrImpl ::
//   Fn3 String Boolean NativeAttrs NativeAttrs
exports.concatBooleanAttrImpl = function(name, b, rest) {
  if (b) {
    var result = Object.assign({}, rest);
    result[name] = name;
    return result;
  } else {
    return rest;
  }
};

// foreign import concatDataAttrImpl ::
//   Fn3 String String NativeAttrs NativeAttrs
exports.concatDataAttrImpl = function(name, val, rest) {
  var result = Object.assign({}, rest);
  var attributes = Object.assign({}, rest.attributes);
  attributes[name] = val;
  result.attributes = attributes;
  return result;
};

// foreign import emptyAttrs :: NativeAttrs
exports.emptyAttrs = function() {
  return {};
};
