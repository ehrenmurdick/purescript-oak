var h = require('virtual-dom/h');
var createElement = require('virtual-dom/create-element');
var diff = require('virtual-dom/diff');
var patch = require('virtual-dom/patch');
var _ = require('lodash');

var App = function(opts) {
  var init = opts.init;
  var view = opts.view;
  var update = opts.update;

  this.init = init;
  this.view = view;
  this.update = update;

  this.model = this.init;

  this.tree = this.render(this.view(this.model));
  this.rootNode = createElement(this.tree);
};

App.prototype.registerHandler = function (name, eventName, view) {
  var handlerOption = _.find(view.options, function(option) {
    return option.constructor.name === name;
  });
  if (handlerOption) {
    var self = this;
    view.__options[eventName] = function() {
      self.handleMsg(handlerOption.value0);
    };
  }
};

App.prototype.render = function (pursView) {
  var view = pursView.value0;
  view.__options = {};
  if (typeof view === 'object') {
    this.registerHandler('OnClick', 'onclick', view);

    return h(view.name, view.__options, _.map(view.children, this.render.bind(this)));
  } else {
    return view;
  }
};

App.prototype.handleMsg = function (msg) {
  this.model = this.update(msg)(this.model);
  var newTree = this.render(this.view(this.model));
  var patches = diff(this.tree, newTree);
  this.rootNode = patch(this.rootNode, patches);
  this.tree = newTree;
};

App.prototype.mount = function (el) {
  el.appendChild(this.rootNode);
};

var nativeCreateApp = function(appOpts) {
  var app = new App(appOpts);
  return app;
};
exports.nativeCreateApp = nativeCreateApp;

var el = function(name, opts, children) {
  return {
    name: name,
    opts: opts,
    children: children
  };
};

var button = function(opts, children) {
  return el('button', opts, children);
};
exports.button = button;

var div = function(opts, children) {
  return el('div', opts, children);
};
exports.div = div;

var input = function(opts, children) {
  return el('input', opts, children);
};
exports.input = input;

var br = function(opts, children) {
  return el('br', opts, children);
};
exports.br = br;
