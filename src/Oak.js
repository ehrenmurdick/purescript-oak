exports.runCmdImpl = function(handler) {
  return function(command) {
    return function() {
      command(handler);
    };
  };
};
