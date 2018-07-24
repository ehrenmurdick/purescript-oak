// DUPLICATED FROM VIRTUALDOM/NATIVE.JS
// foreign import concatOptionImpl :: ∀ eff event.
//   Fn3 String String NativeOptions NativeOptions
var concatOption = function(name, value, rest) {
  var result = Object.assign({}, rest);
  result[name] = value;
  return result;
};
exports.concatOptionImpl = concatOption;
exports.concatNativeOptionsImpl = concatOption;


// foreign import emptyOptions :: NativeOptions
exports.emptyOptions = function() {
  return {};
};