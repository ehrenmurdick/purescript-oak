exports.fetchImpl = function(left, right, url, options, decoder) {
  console.log("FETCH OPTIONS: ", options)
  return function(handler) {
    console.log("FETCHING...")
    fetch(url, options).then(function(resp) {
      return resp.text();
    }).then(function(resp) {
      handler(decoder(right(resp)))();
    }).catch(function(err) {
      handler(decoder(left(String(err))))();
    });
  };
};

// DUPLICATED FROM VIRTUALDOM/NATIVE.JS
// foreign import concatOptionImpl :: ∀ eff event.
//   Fn3 String String NativeOptions NativeOptions
exports.concatOptionImpl = function(name, value, rest) {
  var result = Object.assign({}, rest);
  result[name] = value;
  return result;
};

// DUPLICATED FROM VIRTUALDOM/NATIVE.JS
// foreign import concatOptionsImpl :: ∀ eff event.
//   Fn3 String String NativeOptions NativeOptions
exports.concatNativeOptionsImpl = function(name, value, rest) {
  var result = Object.assign({}, rest);
  result[name] = value;
  return result;
};

// foreign import emptyOptions :: NativeOptions
exports.emptyOptions = function() {
  return {};
};