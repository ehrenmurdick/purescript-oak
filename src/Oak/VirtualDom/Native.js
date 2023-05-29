let h = require("virtual-dom/h");
let diff = require("virtual-dom/diff");
let patch = require("virtual-dom/patch");
let createElement = require("virtual-dom/create-element");

// foreign import createRootNodeImpl :: ∀ e.
//   Fn1 Tree (Eff ( createRootNode :: NODE | e ) Node)
export function createRootNodeImpl(tree) {
  console.log("tree", tree);
  const el = createElement(tree);
  console.log("el", el);
  return el;
}

// foreign import textImpl :: ∀ e.
//   Fn1 String (Eff e Tree)
export function textImpl(str) {
  return function () {
    return str;
  };
}

// foreign import renderImpl :: ∀ msg h e model.
//   Fn3
//     String
//     NativeAttrs
//     ( Effect (Array Tree) )
//     ( Effect Tree )
export function renderImpl(tagName, attrs, childrenEff) {
  return function () {
    var children = childrenEff();
    return h(tagName, attrs, children);
  };
}

// foreign import patchImpl :: ∀ e h.
//   Fn3 Tree Tree Node (Effect Node)
export function patchImpl(newTree, oldTree, rootNode) {
  return function () {
    var patches = diff(oldTree, newTree);
    return patch(rootNode, patches);
  };
}

// foreign import concatHandlerFunImpl :: ∀ eff event.
//   Fn3 String (event -> eff) NativeAttrs NativeAttrs
export function concatHandlerFunImpl(name, msgHandler, rest) {
  var result = Object.assign({}, rest);
  result[name] = function (event) {
    msgHandler(event)();
  };
  return result;
}

// foreign import concatEventTargetValueHandlerFunImpl :: ∀ eff event.
//   Fn3 String (event -> eff) NativeAttrs NativeAttrs
export function concatEventTargetValueHandlerFunImpl(name, msgHandler, rest) {
  var result = Object.assign({}, rest);
  result[name] = function (event) {
    msgHandler(String(event.target.value))();
  };
  return result;
}

// foreign import concatSimpleAttrImpl :: ∀ eff event.
//   Fn3 String String NativeAttrs NativeAttrs
export function concatSimpleAttrImpl(name, value, rest) {
  var result = Object.assign({}, rest);
  result[name] = value;
  return result;
}

// foreign import concatBooleanAttrImpl ::
//   Fn3 String Boolean NativeAttrs NativeAttrs
export function concatBooleanAttrImpl(name, b, rest) {
  if (b) {
    var result = Object.assign({}, rest);
    result[name] = name;
    return result;
  } else {
    return rest;
  }
}

// foreign import concatDataAttrImpl ::
//   Fn3 String String NativeAttrs NativeAttrs
export function concatDataAttrImpl(name, val, rest) {
  var result = Object.assign({}, rest);
  var attributes = Object.assign({}, rest.attributes);
  attributes[name] = val;
  result.attributes = attributes;
  return result;
}

// foreign import emptyAttrs :: NativeAttrs
export function emptyAttrs() {
  return {};
}
