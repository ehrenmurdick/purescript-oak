exports.mathRandom = function(msgCtor) {
  return function(handler) {
    handler(msgCtor(Math.random()))()
  }
}
