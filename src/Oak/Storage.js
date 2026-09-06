// A Store is the *name* of the store rather than the store itself. Reading
// window.localStorage throws outright when site data is blocked, so the
// lookup has to happen inside the guard, on each call.
function store(name) {
  try {
    return window[name] || null;
  } catch (e) {
    return null;
  }
}

export const localStorage = "localStorage";

export const sessionStorage = "sessionStorage";

export function getItemImpl(name, key) {
  return function () {
    var s = store(name);
    if (s === null) {
      return null;
    }

    try {
      return s.getItem(key);
    } catch (e) {
      return null;
    }
  };
}

export function setItemImpl(name, key, value) {
  return function () {
    var s = store(name);
    if (s === null) {
      return false;
    }

    try {
      s.setItem(key, value);
      return true;
    } catch (e) {
      // most often QuotaExceededError
      return false;
    }
  };
}

export function removeItemImpl(name, key) {
  return function () {
    var s = store(name);
    if (s === null) {
      return;
    }

    try {
      s.removeItem(key);
    } catch (e) {
      // nothing useful to report
    }
  };
}

export function clearImpl(name) {
  return function () {
    var s = store(name);
    if (s === null) {
      return;
    }

    try {
      s.clear();
    } catch (e) {
      // nothing useful to report
    }
  };
}

export function keysImpl(name) {
  return function () {
    var s = store(name);
    if (s === null) {
      return [];
    }

    try {
      var out = [];
      for (var i = 0; i < s.length; i++) {
        out.push(s.key(i));
      }
      return out;
    } catch (e) {
      return [];
    }
  };
}
