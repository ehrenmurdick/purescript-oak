exports.getImpl = function(left, right, url, decoder) {
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
