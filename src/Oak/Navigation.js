// Module-level state, for two reasons. The mode decides which half of the
// URL carries the route, and every function here needs to agree on it
// without being handed it each time. And history.pushState fires no event of
// its own, so a push has to announce its own navigation to a dispatcher that
// was registered long before the push happened.
var mode = "path";
var notify = null;
var lastUrl = null;

function read() {
  return (
    window.location.pathname + window.location.search + window.location.hash
  );
}

function hashHref(url) {
  return "#" + (url.charAt(0) === "#" ? url.slice(1) : url);
}

// Every navigation funnels through here, and the dedupe covers three cases
// at once: a hash-mode push that also fires hashchange, a click on a link to
// the screen already showing, and a popstate that lands where we already are.
function announce() {
  var url = read();
  if (url === lastUrl) {
    return;
  }
  lastUrl = url;
  if (notify) {
    notify(url)();
  }
}

export function currentUrl() {
  return read();
}

export function pushImpl(url) {
  return function () {
    if (mode === "hash") {
      // Assigning .hash fires hashchange, which announces for us. pushState
      // is not an option here: it throws on file:// origins, and being able
      // to run from a file:// origin is the main reason to be in hash mode.
      window.location.hash = hashHref(url);
    } else {
      window.history.pushState(null, "", url);
      announce();
    }
  };
}

export function replaceImpl(url) {
  return function () {
    if (mode === "hash") {
      window.location.replace(hashHref(url));
    } else {
      window.history.replaceState(null, "", url);
      announce();
    }
  };
}

export function back() {
  window.history.back();
}

export function forward() {
  window.history.forward();
}

export function loadImpl(url) {
  return function () {
    window.location.href = url;
  };
}

// Returns the app-level path an anchor points at, or null to let the browser
// handle the click normally.
function routeFor(href) {
  // Anything that is not http(s) or relative -- mailto:, tel: -- is the
  // browser's business.
  if (/^[a-zA-Z][a-zA-Z0-9+.-]*:/.test(href) && !/^https?:/i.test(href)) {
    return null;
  }

  var url;
  try {
    url = new URL(href, window.location.href);
  } catch (e) {
    return null;
  }

  if (url.origin !== window.location.origin) {
    return null;
  }

  if (mode === "hash") {
    // Both `href="#/todos"` and `href="/todos"` are accepted, so view code
    // does not have to change when the mode flag does. The cost is that a
    // bare path cannot reach another document while in hash mode -- use
    // rel="external" or a target for that.
    if (url.hash) {
      return url.hash.slice(1);
    }
    return url.pathname + url.search;
  }

  return url.pathname + url.search + url.hash;
}

function onClick(event) {
  if (event.defaultPrevented) {
    return;
  }
  // Middle-click opens a tab and right-click opens a menu; a held modifier
  // means the person is deliberately asking for browser behaviour.
  if (event.button !== 0) {
    return;
  }
  if (event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) {
    return;
  }

  var target = event.target;
  if (!target || typeof target.closest !== "function") {
    return;
  }

  // closest, so a click on something nested inside the anchor still counts.
  var anchor = target.closest("a[href]");
  if (!anchor) {
    return;
  }
  if (anchor.hasAttribute("download")) {
    return;
  }

  var explicitTarget = anchor.getAttribute("target");
  if (explicitTarget && explicitTarget !== "_self") {
    return;
  }

  var rel = anchor.getAttribute("rel") || "";
  if (rel.split(/\s+/).indexOf("external") !== -1) {
    return;
  }

  var route = routeFor(anchor.getAttribute("href"));
  if (route === null) {
    return;
  }

  event.preventDefault();
  pushImpl(route)();
}

export function startImpl(modeTag, dispatch) {
  return function () {
    mode = modeTag;
    notify = dispatch;
    lastUrl = read();

    if (mode === "path" && window.location.protocol === "file:") {
      console.warn(
        "Oak: Path routing cannot work from a file:// URL, because " +
          "history.pushState throws on this origin. Use Oak.Route.Hash, or " +
          "serve the app over http."
      );
    }

    window.addEventListener("popstate", announce);
    window.addEventListener("hashchange", announce);

    // Bubble phase rather than capture, so a handler on the anchor itself
    // runs first and a handler that calls preventDefault is respected.
    document.addEventListener("click", onClick);
  };
}
