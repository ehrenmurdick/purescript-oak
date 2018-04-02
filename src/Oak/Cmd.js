exports.noneImpl = function() {
};

exports.getImpl = function(left) {
  return function(right) {
    return function(url) {
      return function(decoder) {
        return function(handler) {
          fetch(url).then(function(resp) {
            return resp.text();
          }).then(function(resp) {
            handler(decoder(right(resp)))();
          }).catch(function(err) {
            handler(decoder(left(String(err))))();
          });
        };
      };
    };
  };
};
