exports.runCmdImpl = function(commandHandlerChain) {
    return function() {
      setTimeout(commandHandlerChain, 0);
  };
};
