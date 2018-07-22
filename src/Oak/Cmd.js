exports.noneImpl = function() {
};


exports.appendImpl = function(a, b) {
  return function(handler) {
    a(handler);
    b(handler);
  };
};
