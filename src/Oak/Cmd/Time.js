exports.delayImpl = function(amt, msg) {
  return function(handler) {
    setTimeout(function() {
      handler(msg)();
    }, amt);
  };
};
