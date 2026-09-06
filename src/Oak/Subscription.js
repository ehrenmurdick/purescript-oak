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
