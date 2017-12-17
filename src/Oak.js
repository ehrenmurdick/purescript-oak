var h = require('virtual-dom/h');
var createElement = require('virtual-dom/create-element');
// var diff = require('virtual-dom/diff');
// var patch = require('virtual-dom/patch');
// var _ = require('lodash');

exports.nativeText = function(str) {
  return String(str);
};

exports.nativeTag = function(name) {
  return function(options) {
    return function(children) {
      return h(name, options, children);
    };
  };
};

// foreign import nativeCreateElement :: VirtualDOM -> NativeDOM
exports.nativeCreateElement = function(tree) {
  return createElement(tree);
};
