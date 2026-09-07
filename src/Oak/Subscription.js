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
