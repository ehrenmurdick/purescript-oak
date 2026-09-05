// The native dialogs block the main thread the instant they are called, and
// Oak calls `next` immediately after `patch`, so calling them straight away
// would freeze the page on top of a view the browser has not repainted yet.
// A rAF followed by a timeout lands us just after the pending paint.
function defer(run) {
  if (typeof requestAnimationFrame === "function") {
    requestAnimationFrame(function () {
      setTimeout(run, 0);
    });
  } else {
    setTimeout(run, 0);
  }
}

export function alertImpl(message, done) {
  return function () {
    defer(function () {
      window.alert(message);
      done();
    });
  };
}

export function confirmImpl(message, k) {
  return function () {
    defer(function () {
      k(window.confirm(message))();
    });
  };
}

export function promptImpl(message, defaultValue, k) {
  return function () {
    defer(function () {
      k(window.prompt(message, defaultValue))();
    });
  };
}
