import h from "virtual-dom/h.js";
import diff from "virtual-dom/diff.js";
import patch from "virtual-dom/patch.js";
import createElement from "virtual-dom/create-element.js";

// foreign import createRootNodeImpl :: ∀ e.
//   Fn1 Tree (Eff ( createRootNode :: NODE | e ) Node)
export function createRootNodeImpl(tree) {
  return createElement(tree);
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

// foreign import concatPreventingHandlerFunImpl :: ∀ eff event.
//   Fn3 String (event -> eff) NativeAttrs NativeAttrs
//
// Same as concatHandlerFunImpl, but cancels the browser's default action
// first. This is what makes onSubmit usable: without it a form dispatches
// its message and then reloads the page out from under the app that just
// handled it.
export function concatPreventingHandlerFunImpl(name, msgHandler, rest) {
  var result = Object.assign({}, rest);
  result[name] = function (event) {
    if (event && typeof event.preventDefault === "function") {
      event.preventDefault();
    }
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

// A virtual-dom hook. Properties like `checked` and `value` are edited by the
// user directly on the live node, so the real DOM drifts away from what the
// vdom thinks is there and an ordinary property diff has nothing to correct.
// A hook runs on every patch that includes it, so it can re-assert the value
// regardless of what the diff believes.
function ForcedProp(value) {
  this.value = value;
}

// isHook() rejects own properties -- it tests
//   typeof h.hook === "function" && !h.hasOwnProperty("hook")
// so this MUST be on the prototype. An object literal { hook: fn } is not a
// hook: virtual-dom applies it as an ordinary property, with no error.
ForcedProp.prototype.hook = function (node, propName) {
  // Guard the write: assigning .value unconditionally resets the caret and
  // can break IME composition mid-word.
  if (node[propName] !== this.value) {
    node[propName] = this.value;
  }
};

// foreign import concatForcedBooleanAttrImpl ::
//   Fn3 String Boolean NativeAttrs NativeAttrs
export function concatForcedBooleanAttrImpl(name, b, rest) {
  var result = Object.assign({}, rest);
  // A fresh instance every render, deliberately. diffProps short-circuits on
  // aValue === bValue, so memoising these would drop the hook out of the diff
  // and silently disable the whole mechanism.
  result[name] = new ForcedProp(b);
  return result;
}

// foreign import concatForcedStringAttrImpl ::
//   Fn3 String String NativeAttrs NativeAttrs
export function concatForcedStringAttrImpl(name, val, rest) {
  var result = Object.assign({}, rest);
  result[name] = new ForcedProp(val);
  return result;
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
