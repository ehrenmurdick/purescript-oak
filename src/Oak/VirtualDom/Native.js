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

// Read the parts of a drag event an Oak app can use, as the DragEvent record
// in Oak.Html.Attribute.
//
// getData() only returns the payload during `drop`. While a drag is in
// flight the spec puts the drag data in "protected mode" and every earlier
// event reads back as an empty string -- that is the browser's rule, not
// ours. Some browsers throw rather than return "" outside a drop, so the
// read is guarded.
//
// NOTE: Oak/Subscription.js carries a copy of this. PureScript FFI modules
// are compiled into separate output directories and cannot import from one
// another, so the two have to be kept in step by hand.
function readDragEvent(event) {
  var payload = "";
  if (event && event.dataTransfer) {
    try {
      payload = event.dataTransfer.getData("text/plain") || "";
    } catch (e) {
      payload = "";
    }
  }
  return {
    altKey: !!(event && event.altKey),
    clientX: event && typeof event.clientX === "number" ? event.clientX : 0.0,
    clientY: event && typeof event.clientY === "number" ? event.clientY : 0.0,
    ctrlKey: !!(event && event.ctrlKey),
    dataTransfer: payload,
    metaKey: !!(event && event.metaKey),
    shiftKey: !!(event && event.shiftKey),
  };
}

// foreign import concatDragHandlerFunImpl :: ∀ eff.
//   Fn3 String (DragEvent -> eff) NativeAttrs NativeAttrs
export function concatDragHandlerFunImpl(name, msgHandler, rest) {
  var result = Object.assign({}, rest);
  result[name] = function (event) {
    msgHandler(readDragEvent(event))();
  };
  return result;
}

// foreign import concatPreventingDragHandlerFunImpl :: ∀ eff.
//   Fn3 String (DragEvent -> eff) NativeAttrs NativeAttrs
//
// `drop` needs the cancel as much as the read: without it the browser
// follows its default action for the dropped data, which for text is to
// navigate away from the app that was about to handle it.
export function concatPreventingDragHandlerFunImpl(name, msgHandler, rest) {
  var result = Object.assign({}, rest);
  result[name] = function (event) {
    if (event && typeof event.preventDefault === "function") {
      event.preventDefault();
    }
    msgHandler(readDragEvent(event))();
  };
  return result;
}

// foreign import concatDataTransferHandlerFunImpl :: ∀ eff event.
//   Fn4 String String (event -> eff) NativeAttrs NativeAttrs
//
// The dragstart half of the protocol. Setting the data is what makes the
// drag real -- Firefox will not start one otherwise -- and effectAllowed is
// what gets the pointer a move cursor instead of the "no entry" one.
// Deliberately does NOT preventDefault: cancelling dragstart cancels the
// drag.
export function concatDataTransferHandlerFunImpl(name, payload, msgHandler, rest) {
  var result = Object.assign({}, rest);
  result[name] = function (event) {
    if (event && event.dataTransfer) {
      try {
        event.dataTransfer.setData("text/plain", payload);
        event.dataTransfer.effectAllowed = "move";
      } catch (e) {
        // A browser that refuses the write still gets the message; the drop
        // handler will see an empty payload and can fall back to the model.
      }
    }
    msgHandler(event)();
  };
  return result;
}

// foreign import concatPreventDefaultImpl ::
//   Fn2 String NativeAttrs NativeAttrs
//
// Cancel and stay quiet. This is what a drop target puts on `dragover`: the
// event has to be cancelled on every frame for the element to accept a drop,
// and every frame turned into a message would be a full render and diff.
export function concatPreventDefaultImpl(name, rest) {
  var result = Object.assign({}, rest);
  result[name] = function (event) {
    if (event && typeof event.preventDefault === "function") {
      event.preventDefault();
    }
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
