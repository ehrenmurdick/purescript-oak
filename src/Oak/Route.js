// decodeURIComponent throws on malformed input ("%zz", a lone "%"), and a
// bad character in a URL should not take the whole app down -- a segment we
// cannot decode is handed back exactly as it arrived, and simply won't match
// the route the author expected.
export function decodeComponent(s) {
  try {
    return decodeURIComponent(s);
  } catch (e) {
    return s;
  }
}
