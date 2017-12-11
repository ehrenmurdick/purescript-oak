var h = require('virtual-dom/h');
var createElement = require('virtual-dom/create-element');
var diff = require('virtual-dom/diff');
var patch = require('virtual-dom/patch');
var map = require('lodash').map;

function App(options) {
  this.init = options.init;
  this.view = options.view;
  this.update = options.update;

  this.model = this.init();

  this.tree = this.render(this.view(this.model));
  this.rootNode = createElement(this.tree);
}

App.prototype = {
  registerHandler: function(name, view) {
    if (view.opts && view.opts[name]) {
      var ctor = view.opts[name];
      var self = this;
      view.opts[name] = function(e) {
        self.handleMsg(new ctor(e));
      };
    }
    return view;
  },

  render: function(view) {
    if (typeof view === 'object') {
      this.registerHandler('onclick', view);
      this.registerHandler('oninput', view);

      return h(view.name, view.opts, map(view.children, this.render.bind(this)));
    } else {
      return view;
    }
  },

  handleMsg: function(msg) {
    this.model = this.update(msg, this.model);
    var newTree = this.render(this.view(this.model));
    var patches = diff(this.tree, newTree);
    this.rootNode = patch(this.rootNode, patches);
    this.tree = newTree;
  },

  mount: function(el) {
    el.appendChild(this.rootNode);
  }
};

exports.createAppImpl = function(appOpts) {
  var app = new App(appOpts);
  return app;
};

var el = function(name, opts, children) {
  return {
    name: name,
    opts: opts,
    children: children
  };
};
exports.elImpl = el;

exports.button = function(opts, children) {
  return el('button', opts, children);
};

var div = function(opts, children) {
  return el('div', opts, children);
};
exports.divImpl = div;

var input = function(opts, children) {
  return el('input', opts, children);
};
exports.inputImpl = input;

var br =  function(opts, children) {
  return el('br', opts, children);
};
exports.brImpl = br;
