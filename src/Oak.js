exports.finalizeRootNode = function(eff) {
  return eff;
};

exports.runCmdImpl = function(handler) {
  return function(command) {
    return function() {
      command(handler);
    };
  };
};
