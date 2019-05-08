exports.runCmdImpl = function(commandHandlerChain) {
    return function() {
      commandHandlerChain();
  };
};
