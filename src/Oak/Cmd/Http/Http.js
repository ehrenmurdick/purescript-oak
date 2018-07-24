exports.fetchImpl = function(left, right, url, options, decoder) {
  console.log("FETCH OPTIONS: ", options)
  return function(handler) {
    console.log("FETCHING...")
    fetch(url, options).then(function(resp) {
      return resp.text();
    }).then(function(resp) {
      handler(decoder(right(resp)))();
    }).catch(function(err) {
      handler(decoder(left(String(err))))();
    });
  };
};