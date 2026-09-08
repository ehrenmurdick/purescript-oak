export function addWindowListenerImpl(name, action) {
  return function () {
    // Held onto so the unsubscribe effect can hand removeEventListener the
    // same function reference addEventListener was given.
    var listener = function () {
      action();
    };

    window.addEventListener(name, listener);

    return function () {
      window.removeEventListener(name, listener);
    };
  };
}

// Same reader as the one in Oak/VirtualDom/Native.js, which carries the
// commentary. PureScript compiles each FFI module into its own output
// directory and they cannot import from one another, so the two copies have
// to be kept in step by hand.
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

// Deliberately does not preventDefault. A subscription is a listener, not a
// participant: making the whole window accept drops is a decision an app
// makes per element, with Oak.Html.Events.allowDrop.
export function addWindowDragListenerImpl(name, action) {
  return function () {
    var listener = function (event) {
      action(readDragEvent(event))();
    };

    window.addEventListener(name, listener);

    return function () {
      window.removeEventListener(name, listener);
    };
  };
}

export function setIntervalImpl(ms, action) {
  return function () {
    return setInterval(function () {
      action();
    }, ms);
  };
}

export function clearIntervalImpl(id) {
  return function () {
    clearInterval(id);
  };
}

export function setTimeoutImpl(ms, action) {
  return function () {
    return setTimeout(function () {
      action();
    }, ms);
  };
}

export function clearTimeoutImpl(id) {
  return function () {
    clearTimeout(id);
  };
}
