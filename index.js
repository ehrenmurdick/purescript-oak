(() => {
  var __getOwnPropNames = Object.getOwnPropertyNames;
  var __commonJS = (cb, mod2) => function __require() {
    return mod2 || (0, cb[__getOwnPropNames(cb)[0]])((mod2 = { exports: {} }).exports, mod2), mod2.exports;
  };

  // node_modules/x-is-array/index.js
  var require_x_is_array = __commonJS({
    "node_modules/x-is-array/index.js"(exports, module) {
      var nativeIsArray = Array.isArray;
      var toString6 = Object.prototype.toString;
      module.exports = nativeIsArray || isArray2;
      function isArray2(obj) {
        return toString6.call(obj) === "[object Array]";
      }
    }
  });

  // node_modules/virtual-dom/vnode/version.js
  var require_version = __commonJS({
    "node_modules/virtual-dom/vnode/version.js"(exports, module) {
      module.exports = "2";
    }
  });

  // node_modules/virtual-dom/vnode/is-vnode.js
  var require_is_vnode = __commonJS({
    "node_modules/virtual-dom/vnode/is-vnode.js"(exports, module) {
      var version = require_version();
      module.exports = isVirtualNode;
      function isVirtualNode(x) {
        return x && x.type === "VirtualNode" && x.version === version;
      }
    }
  });

  // node_modules/virtual-dom/vnode/is-widget.js
  var require_is_widget = __commonJS({
    "node_modules/virtual-dom/vnode/is-widget.js"(exports, module) {
      module.exports = isWidget;
      function isWidget(w) {
        return w && w.type === "Widget";
      }
    }
  });

  // node_modules/virtual-dom/vnode/is-thunk.js
  var require_is_thunk = __commonJS({
    "node_modules/virtual-dom/vnode/is-thunk.js"(exports, module) {
      module.exports = isThunk;
      function isThunk(t) {
        return t && t.type === "Thunk";
      }
    }
  });

  // node_modules/virtual-dom/vnode/is-vhook.js
  var require_is_vhook = __commonJS({
    "node_modules/virtual-dom/vnode/is-vhook.js"(exports, module) {
      module.exports = isHook;
      function isHook(hook) {
        return hook && (typeof hook.hook === "function" && !hook.hasOwnProperty("hook") || typeof hook.unhook === "function" && !hook.hasOwnProperty("unhook"));
      }
    }
  });

  // node_modules/virtual-dom/vnode/vnode.js
  var require_vnode = __commonJS({
    "node_modules/virtual-dom/vnode/vnode.js"(exports, module) {
      var version = require_version();
      var isVNode = require_is_vnode();
      var isWidget = require_is_widget();
      var isThunk = require_is_thunk();
      var isVHook = require_is_vhook();
      module.exports = VirtualNode;
      var noProperties = {};
      var noChildren = [];
      function VirtualNode(tagName, properties, children, key, namespace) {
        this.tagName = tagName;
        this.properties = properties || noProperties;
        this.children = children || noChildren;
        this.key = key != null ? String(key) : void 0;
        this.namespace = typeof namespace === "string" ? namespace : null;
        var count = children && children.length || 0;
        var descendants = 0;
        var hasWidgets = false;
        var hasThunks = false;
        var descendantHooks = false;
        var hooks;
        for (var propName in properties) {
          if (properties.hasOwnProperty(propName)) {
            var property = properties[propName];
            if (isVHook(property) && property.unhook) {
              if (!hooks) {
                hooks = {};
              }
              hooks[propName] = property;
            }
          }
        }
        for (var i2 = 0; i2 < count; i2++) {
          var child = children[i2];
          if (isVNode(child)) {
            descendants += child.count || 0;
            if (!hasWidgets && child.hasWidgets) {
              hasWidgets = true;
            }
            if (!hasThunks && child.hasThunks) {
              hasThunks = true;
            }
            if (!descendantHooks && (child.hooks || child.descendantHooks)) {
              descendantHooks = true;
            }
          } else if (!hasWidgets && isWidget(child)) {
            if (typeof child.destroy === "function") {
              hasWidgets = true;
            }
          } else if (!hasThunks && isThunk(child)) {
            hasThunks = true;
          }
        }
        this.count = count + descendants;
        this.hasWidgets = hasWidgets;
        this.hasThunks = hasThunks;
        this.hooks = hooks;
        this.descendantHooks = descendantHooks;
      }
      VirtualNode.prototype.version = version;
      VirtualNode.prototype.type = "VirtualNode";
    }
  });

  // node_modules/virtual-dom/vnode/vtext.js
  var require_vtext = __commonJS({
    "node_modules/virtual-dom/vnode/vtext.js"(exports, module) {
      var version = require_version();
      module.exports = VirtualText;
      function VirtualText(text5) {
        this.text = String(text5);
      }
      VirtualText.prototype.version = version;
      VirtualText.prototype.type = "VirtualText";
    }
  });

  // node_modules/virtual-dom/vnode/is-vtext.js
  var require_is_vtext = __commonJS({
    "node_modules/virtual-dom/vnode/is-vtext.js"(exports, module) {
      var version = require_version();
      module.exports = isVirtualText;
      function isVirtualText(x) {
        return x && x.type === "VirtualText" && x.version === version;
      }
    }
  });

  // node_modules/browser-split/index.js
  var require_browser_split = __commonJS({
    "node_modules/browser-split/index.js"(exports, module) {
      module.exports = function split2(undef) {
        var nativeSplit = String.prototype.split, compliantExecNpcg = /()??/.exec("")[1] === undef, self;
        self = function(str, separator, limit) {
          if (Object.prototype.toString.call(separator) !== "[object RegExp]") {
            return nativeSplit.call(str, separator, limit);
          }
          var output2 = [], flags = (separator.ignoreCase ? "i" : "") + (separator.multiline ? "m" : "") + (separator.extended ? "x" : "") + // Proposed for ES6
          (separator.sticky ? "y" : ""), lastLastIndex = 0, separator = new RegExp(separator.source, flags + "g"), separator2, match, lastIndex, lastLength;
          str += "";
          if (!compliantExecNpcg) {
            separator2 = new RegExp("^" + separator.source + "$(?!\\s)", flags);
          }
          limit = limit === undef ? -1 >>> 0 : (
            // Math.pow(2, 32) - 1
            limit >>> 0
          );
          while (match = separator.exec(str)) {
            lastIndex = match.index + match[0].length;
            if (lastIndex > lastLastIndex) {
              output2.push(str.slice(lastLastIndex, match.index));
              if (!compliantExecNpcg && match.length > 1) {
                match[0].replace(separator2, function() {
                  for (var i2 = 1; i2 < arguments.length - 2; i2++) {
                    if (arguments[i2] === undef) {
                      match[i2] = undef;
                    }
                  }
                });
              }
              if (match.length > 1 && match.index < str.length) {
                Array.prototype.push.apply(output2, match.slice(1));
              }
              lastLength = match[0].length;
              lastLastIndex = lastIndex;
              if (output2.length >= limit) {
                break;
              }
            }
            if (separator.lastIndex === match.index) {
              separator.lastIndex++;
            }
          }
          if (lastLastIndex === str.length) {
            if (lastLength || !separator.test("")) {
              output2.push("");
            }
          } else {
            output2.push(str.slice(lastLastIndex));
          }
          return output2.length > limit ? output2.slice(0, limit) : output2;
        };
        return self;
      }();
    }
  });

  // node_modules/virtual-dom/virtual-hyperscript/parse-tag.js
  var require_parse_tag = __commonJS({
    "node_modules/virtual-dom/virtual-hyperscript/parse-tag.js"(exports, module) {
      "use strict";
      var split2 = require_browser_split();
      var classIdSplit = /([\.#]?[a-zA-Z0-9\u007F-\uFFFF_:-]+)/;
      var notClassId = /^\.|#/;
      module.exports = parseTag;
      function parseTag(tag, props) {
        if (!tag) {
          return "DIV";
        }
        var noId = !props.hasOwnProperty("id");
        var tagParts = split2(tag, classIdSplit);
        var tagName = null;
        if (notClassId.test(tagParts[1])) {
          tagName = "DIV";
        }
        var classes, part, type, i2;
        for (i2 = 0; i2 < tagParts.length; i2++) {
          part = tagParts[i2];
          if (!part) {
            continue;
          }
          type = part.charAt(0);
          if (!tagName) {
            tagName = part;
          } else if (type === ".") {
            classes = classes || [];
            classes.push(part.substring(1, part.length));
          } else if (type === "#" && noId) {
            props.id = part.substring(1, part.length);
          }
        }
        if (classes) {
          if (props.className) {
            classes.push(props.className);
          }
          props.className = classes.join(" ");
        }
        return props.namespace ? tagName : tagName.toUpperCase();
      }
    }
  });

  // node_modules/virtual-dom/virtual-hyperscript/hooks/soft-set-hook.js
  var require_soft_set_hook = __commonJS({
    "node_modules/virtual-dom/virtual-hyperscript/hooks/soft-set-hook.js"(exports, module) {
      "use strict";
      module.exports = SoftSetHook;
      function SoftSetHook(value) {
        if (!(this instanceof SoftSetHook)) {
          return new SoftSetHook(value);
        }
        this.value = value;
      }
      SoftSetHook.prototype.hook = function(node, propertyName) {
        if (node[propertyName] !== this.value) {
          node[propertyName] = this.value;
        }
      };
    }
  });

  // node_modules/individual/index.js
  var require_individual = __commonJS({
    "node_modules/individual/index.js"(exports, module) {
      "use strict";
      var root = typeof window !== "undefined" ? window : typeof global !== "undefined" ? global : {};
      module.exports = Individual;
      function Individual(key, value) {
        if (key in root) {
          return root[key];
        }
        root[key] = value;
        return value;
      }
    }
  });

  // node_modules/individual/one-version.js
  var require_one_version = __commonJS({
    "node_modules/individual/one-version.js"(exports, module) {
      "use strict";
      var Individual = require_individual();
      module.exports = OneVersion;
      function OneVersion(moduleName, version, defaultValue) {
        var key = "__INDIVIDUAL_ONE_VERSION_" + moduleName;
        var enforceKey = key + "_ENFORCE_SINGLETON";
        var versionValue = Individual(enforceKey, version);
        if (versionValue !== version) {
          throw new Error("Can only have one copy of " + moduleName + ".\nYou already have version " + versionValue + " installed.\nThis means you cannot install version " + version);
        }
        return Individual(key, defaultValue);
      }
    }
  });

  // node_modules/ev-store/index.js
  var require_ev_store = __commonJS({
    "node_modules/ev-store/index.js"(exports, module) {
      "use strict";
      var OneVersionConstraint = require_one_version();
      var MY_VERSION = "7";
      OneVersionConstraint("ev-store", MY_VERSION);
      var hashKey = "__EV_STORE_KEY@" + MY_VERSION;
      module.exports = EvStore;
      function EvStore(elem2) {
        var hash = elem2[hashKey];
        if (!hash) {
          hash = elem2[hashKey] = {};
        }
        return hash;
      }
    }
  });

  // node_modules/virtual-dom/virtual-hyperscript/hooks/ev-hook.js
  var require_ev_hook = __commonJS({
    "node_modules/virtual-dom/virtual-hyperscript/hooks/ev-hook.js"(exports, module) {
      "use strict";
      var EvStore = require_ev_store();
      module.exports = EvHook;
      function EvHook(value) {
        if (!(this instanceof EvHook)) {
          return new EvHook(value);
        }
        this.value = value;
      }
      EvHook.prototype.hook = function(node, propertyName) {
        var es = EvStore(node);
        var propName = propertyName.substr(3);
        es[propName] = this.value;
      };
      EvHook.prototype.unhook = function(node, propertyName) {
        var es = EvStore(node);
        var propName = propertyName.substr(3);
        es[propName] = void 0;
      };
    }
  });

  // node_modules/virtual-dom/virtual-hyperscript/index.js
  var require_virtual_hyperscript = __commonJS({
    "node_modules/virtual-dom/virtual-hyperscript/index.js"(exports, module) {
      "use strict";
      var isArray2 = require_x_is_array();
      var VNode = require_vnode();
      var VText = require_vtext();
      var isVNode = require_is_vnode();
      var isVText = require_is_vtext();
      var isWidget = require_is_widget();
      var isHook = require_is_vhook();
      var isVThunk = require_is_thunk();
      var parseTag = require_parse_tag();
      var softSetHook = require_soft_set_hook();
      var evHook = require_ev_hook();
      module.exports = h7;
      function h7(tagName, properties, children) {
        var childNodes = [];
        var tag, props, key, namespace;
        if (!children && isChildren(properties)) {
          children = properties;
          props = {};
        }
        props = props || properties || {};
        tag = parseTag(tagName, props);
        if (props.hasOwnProperty("key")) {
          key = props.key;
          props.key = void 0;
        }
        if (props.hasOwnProperty("namespace")) {
          namespace = props.namespace;
          props.namespace = void 0;
        }
        if (tag === "INPUT" && !namespace && props.hasOwnProperty("value") && props.value !== void 0 && !isHook(props.value)) {
          props.value = softSetHook(props.value);
        }
        transformProperties(props);
        if (children !== void 0 && children !== null) {
          addChild(children, childNodes, tag, props);
        }
        return new VNode(tag, props, childNodes, key, namespace);
      }
      function addChild(c, childNodes, tag, props) {
        if (typeof c === "string") {
          childNodes.push(new VText(c));
        } else if (typeof c === "number") {
          childNodes.push(new VText(String(c)));
        } else if (isChild(c)) {
          childNodes.push(c);
        } else if (isArray2(c)) {
          for (var i2 = 0; i2 < c.length; i2++) {
            addChild(c[i2], childNodes, tag, props);
          }
        } else if (c === null || c === void 0) {
          return;
        } else {
          throw UnexpectedVirtualElement({
            foreignObject: c,
            parentVnode: {
              tagName: tag,
              properties: props
            }
          });
        }
      }
      function transformProperties(props) {
        for (var propName in props) {
          if (props.hasOwnProperty(propName)) {
            var value = props[propName];
            if (isHook(value)) {
              continue;
            }
            if (propName.substr(0, 3) === "ev-") {
              props[propName] = evHook(value);
            }
          }
        }
      }
      function isChild(x) {
        return isVNode(x) || isVText(x) || isWidget(x) || isVThunk(x);
      }
      function isChildren(x) {
        return typeof x === "string" || isArray2(x) || isChild(x);
      }
      function UnexpectedVirtualElement(data) {
        var err = new Error();
        err.type = "virtual-hyperscript.unexpected.virtual-element";
        err.message = "Unexpected virtual child passed to h().\nExpected a VNode / Vthunk / VWidget / string but:\ngot:\n" + errorString(data.foreignObject) + ".\nThe parent vnode is:\n" + errorString(data.parentVnode);
        err.foreignObject = data.foreignObject;
        err.parentVnode = data.parentVnode;
        return err;
      }
      function errorString(obj) {
        try {
          return JSON.stringify(obj, null, "    ");
        } catch (e) {
          return String(obj);
        }
      }
    }
  });

  // node_modules/virtual-dom/h.js
  var require_h = __commonJS({
    "node_modules/virtual-dom/h.js"(exports, module) {
      var h7 = require_virtual_hyperscript();
      module.exports = h7;
    }
  });

  // node_modules/virtual-dom/vnode/vpatch.js
  var require_vpatch = __commonJS({
    "node_modules/virtual-dom/vnode/vpatch.js"(exports, module) {
      var version = require_version();
      VirtualPatch.NONE = 0;
      VirtualPatch.VTEXT = 1;
      VirtualPatch.VNODE = 2;
      VirtualPatch.WIDGET = 3;
      VirtualPatch.PROPS = 4;
      VirtualPatch.ORDER = 5;
      VirtualPatch.INSERT = 6;
      VirtualPatch.REMOVE = 7;
      VirtualPatch.THUNK = 8;
      module.exports = VirtualPatch;
      function VirtualPatch(type, vNode, patch4) {
        this.type = Number(type);
        this.vNode = vNode;
        this.patch = patch4;
      }
      VirtualPatch.prototype.version = version;
      VirtualPatch.prototype.type = "VirtualPatch";
    }
  });

  // node_modules/virtual-dom/vnode/handle-thunk.js
  var require_handle_thunk = __commonJS({
    "node_modules/virtual-dom/vnode/handle-thunk.js"(exports, module) {
      var isVNode = require_is_vnode();
      var isVText = require_is_vtext();
      var isWidget = require_is_widget();
      var isThunk = require_is_thunk();
      module.exports = handleThunk;
      function handleThunk(a2, b2) {
        var renderedA = a2;
        var renderedB = b2;
        if (isThunk(b2)) {
          renderedB = renderThunk(b2, a2);
        }
        if (isThunk(a2)) {
          renderedA = renderThunk(a2, null);
        }
        return {
          a: renderedA,
          b: renderedB
        };
      }
      function renderThunk(thunk, previous) {
        var renderedThunk = thunk.vnode;
        if (!renderedThunk) {
          renderedThunk = thunk.vnode = thunk.render(previous);
        }
        if (!(isVNode(renderedThunk) || isVText(renderedThunk) || isWidget(renderedThunk))) {
          throw new Error("thunk did not return a valid node");
        }
        return renderedThunk;
      }
    }
  });

  // node_modules/is-object/index.js
  var require_is_object = __commonJS({
    "node_modules/is-object/index.js"(exports, module) {
      "use strict";
      module.exports = function isObject(x) {
        return typeof x === "object" && x !== null;
      };
    }
  });

  // node_modules/virtual-dom/vtree/diff-props.js
  var require_diff_props = __commonJS({
    "node_modules/virtual-dom/vtree/diff-props.js"(exports, module) {
      var isObject = require_is_object();
      var isHook = require_is_vhook();
      module.exports = diffProps;
      function diffProps(a2, b2) {
        var diff2;
        for (var aKey in a2) {
          if (!(aKey in b2)) {
            diff2 = diff2 || {};
            diff2[aKey] = void 0;
          }
          var aValue = a2[aKey];
          var bValue = b2[aKey];
          if (aValue === bValue) {
            continue;
          } else if (isObject(aValue) && isObject(bValue)) {
            if (getPrototype(bValue) !== getPrototype(aValue)) {
              diff2 = diff2 || {};
              diff2[aKey] = bValue;
            } else if (isHook(bValue)) {
              diff2 = diff2 || {};
              diff2[aKey] = bValue;
            } else {
              var objectDiff = diffProps(aValue, bValue);
              if (objectDiff) {
                diff2 = diff2 || {};
                diff2[aKey] = objectDiff;
              }
            }
          } else {
            diff2 = diff2 || {};
            diff2[aKey] = bValue;
          }
        }
        for (var bKey in b2) {
          if (!(bKey in a2)) {
            diff2 = diff2 || {};
            diff2[bKey] = b2[bKey];
          }
        }
        return diff2;
      }
      function getPrototype(value) {
        if (Object.getPrototypeOf) {
          return Object.getPrototypeOf(value);
        } else if (value.__proto__) {
          return value.__proto__;
        } else if (value.constructor) {
          return value.constructor.prototype;
        }
      }
    }
  });

  // node_modules/virtual-dom/vtree/diff.js
  var require_diff = __commonJS({
    "node_modules/virtual-dom/vtree/diff.js"(exports, module) {
      var isArray2 = require_x_is_array();
      var VPatch = require_vpatch();
      var isVNode = require_is_vnode();
      var isVText = require_is_vtext();
      var isWidget = require_is_widget();
      var isThunk = require_is_thunk();
      var handleThunk = require_handle_thunk();
      var diffProps = require_diff_props();
      module.exports = diff2;
      function diff2(a2, b2) {
        var patch4 = { a: a2 };
        walk(a2, b2, patch4, 0);
        return patch4;
      }
      function walk(a2, b2, patch4, index2) {
        if (a2 === b2) {
          return;
        }
        var apply2 = patch4[index2];
        var applyClear = false;
        if (isThunk(a2) || isThunk(b2)) {
          thunks(a2, b2, patch4, index2);
        } else if (b2 == null) {
          if (!isWidget(a2)) {
            clearState(a2, patch4, index2);
            apply2 = patch4[index2];
          }
          apply2 = appendPatch(apply2, new VPatch(VPatch.REMOVE, a2, b2));
        } else if (isVNode(b2)) {
          if (isVNode(a2)) {
            if (a2.tagName === b2.tagName && a2.namespace === b2.namespace && a2.key === b2.key) {
              var propsPatch = diffProps(a2.properties, b2.properties);
              if (propsPatch) {
                apply2 = appendPatch(
                  apply2,
                  new VPatch(VPatch.PROPS, a2, propsPatch)
                );
              }
              apply2 = diffChildren(a2, b2, patch4, apply2, index2);
            } else {
              apply2 = appendPatch(apply2, new VPatch(VPatch.VNODE, a2, b2));
              applyClear = true;
            }
          } else {
            apply2 = appendPatch(apply2, new VPatch(VPatch.VNODE, a2, b2));
            applyClear = true;
          }
        } else if (isVText(b2)) {
          if (!isVText(a2)) {
            apply2 = appendPatch(apply2, new VPatch(VPatch.VTEXT, a2, b2));
            applyClear = true;
          } else if (a2.text !== b2.text) {
            apply2 = appendPatch(apply2, new VPatch(VPatch.VTEXT, a2, b2));
          }
        } else if (isWidget(b2)) {
          if (!isWidget(a2)) {
            applyClear = true;
          }
          apply2 = appendPatch(apply2, new VPatch(VPatch.WIDGET, a2, b2));
        }
        if (apply2) {
          patch4[index2] = apply2;
        }
        if (applyClear) {
          clearState(a2, patch4, index2);
        }
      }
      function diffChildren(a2, b2, patch4, apply2, index2) {
        var aChildren = a2.children;
        var orderedSet = reorder(aChildren, b2.children);
        var bChildren = orderedSet.children;
        var aLen = aChildren.length;
        var bLen = bChildren.length;
        var len = aLen > bLen ? aLen : bLen;
        for (var i2 = 0; i2 < len; i2++) {
          var leftNode = aChildren[i2];
          var rightNode = bChildren[i2];
          index2 += 1;
          if (!leftNode) {
            if (rightNode) {
              apply2 = appendPatch(
                apply2,
                new VPatch(VPatch.INSERT, null, rightNode)
              );
            }
          } else {
            walk(leftNode, rightNode, patch4, index2);
          }
          if (isVNode(leftNode) && leftNode.count) {
            index2 += leftNode.count;
          }
        }
        if (orderedSet.moves) {
          apply2 = appendPatch(apply2, new VPatch(
            VPatch.ORDER,
            a2,
            orderedSet.moves
          ));
        }
        return apply2;
      }
      function clearState(vNode, patch4, index2) {
        unhook(vNode, patch4, index2);
        destroyWidgets(vNode, patch4, index2);
      }
      function destroyWidgets(vNode, patch4, index2) {
        if (isWidget(vNode)) {
          if (typeof vNode.destroy === "function") {
            patch4[index2] = appendPatch(
              patch4[index2],
              new VPatch(VPatch.REMOVE, vNode, null)
            );
          }
        } else if (isVNode(vNode) && (vNode.hasWidgets || vNode.hasThunks)) {
          var children = vNode.children;
          var len = children.length;
          for (var i2 = 0; i2 < len; i2++) {
            var child = children[i2];
            index2 += 1;
            destroyWidgets(child, patch4, index2);
            if (isVNode(child) && child.count) {
              index2 += child.count;
            }
          }
        } else if (isThunk(vNode)) {
          thunks(vNode, null, patch4, index2);
        }
      }
      function thunks(a2, b2, patch4, index2) {
        var nodes = handleThunk(a2, b2);
        var thunkPatch = diff2(nodes.a, nodes.b);
        if (hasPatches(thunkPatch)) {
          patch4[index2] = new VPatch(VPatch.THUNK, null, thunkPatch);
        }
      }
      function hasPatches(patch4) {
        for (var index2 in patch4) {
          if (index2 !== "a") {
            return true;
          }
        }
        return false;
      }
      function unhook(vNode, patch4, index2) {
        if (isVNode(vNode)) {
          if (vNode.hooks) {
            patch4[index2] = appendPatch(
              patch4[index2],
              new VPatch(
                VPatch.PROPS,
                vNode,
                undefinedKeys(vNode.hooks)
              )
            );
          }
          if (vNode.descendantHooks || vNode.hasThunks) {
            var children = vNode.children;
            var len = children.length;
            for (var i2 = 0; i2 < len; i2++) {
              var child = children[i2];
              index2 += 1;
              unhook(child, patch4, index2);
              if (isVNode(child) && child.count) {
                index2 += child.count;
              }
            }
          }
        } else if (isThunk(vNode)) {
          thunks(vNode, null, patch4, index2);
        }
      }
      function undefinedKeys(obj) {
        var result = {};
        for (var key in obj) {
          result[key] = void 0;
        }
        return result;
      }
      function reorder(aChildren, bChildren) {
        var bChildIndex = keyIndex(bChildren);
        var bKeys = bChildIndex.keys;
        var bFree = bChildIndex.free;
        if (bFree.length === bChildren.length) {
          return {
            children: bChildren,
            moves: null
          };
        }
        var aChildIndex = keyIndex(aChildren);
        var aKeys = aChildIndex.keys;
        var aFree = aChildIndex.free;
        if (aFree.length === aChildren.length) {
          return {
            children: bChildren,
            moves: null
          };
        }
        var newChildren = [];
        var freeIndex = 0;
        var freeCount = bFree.length;
        var deletedItems = 0;
        for (var i2 = 0; i2 < aChildren.length; i2++) {
          var aItem = aChildren[i2];
          var itemIndex;
          if (aItem.key) {
            if (bKeys.hasOwnProperty(aItem.key)) {
              itemIndex = bKeys[aItem.key];
              newChildren.push(bChildren[itemIndex]);
            } else {
              itemIndex = i2 - deletedItems++;
              newChildren.push(null);
            }
          } else {
            if (freeIndex < freeCount) {
              itemIndex = bFree[freeIndex++];
              newChildren.push(bChildren[itemIndex]);
            } else {
              itemIndex = i2 - deletedItems++;
              newChildren.push(null);
            }
          }
        }
        var lastFreeIndex = freeIndex >= bFree.length ? bChildren.length : bFree[freeIndex];
        for (var j = 0; j < bChildren.length; j++) {
          var newItem = bChildren[j];
          if (newItem.key) {
            if (!aKeys.hasOwnProperty(newItem.key)) {
              newChildren.push(newItem);
            }
          } else if (j >= lastFreeIndex) {
            newChildren.push(newItem);
          }
        }
        var simulate = newChildren.slice();
        var simulateIndex = 0;
        var removes = [];
        var inserts = [];
        var simulateItem;
        for (var k = 0; k < bChildren.length; ) {
          var wantedItem = bChildren[k];
          simulateItem = simulate[simulateIndex];
          while (simulateItem === null && simulate.length) {
            removes.push(remove(simulate, simulateIndex, null));
            simulateItem = simulate[simulateIndex];
          }
          if (!simulateItem || simulateItem.key !== wantedItem.key) {
            if (wantedItem.key) {
              if (simulateItem && simulateItem.key) {
                if (bKeys[simulateItem.key] !== k + 1) {
                  removes.push(remove(simulate, simulateIndex, simulateItem.key));
                  simulateItem = simulate[simulateIndex];
                  if (!simulateItem || simulateItem.key !== wantedItem.key) {
                    inserts.push({ key: wantedItem.key, to: k });
                  } else {
                    simulateIndex++;
                  }
                } else {
                  inserts.push({ key: wantedItem.key, to: k });
                }
              } else {
                inserts.push({ key: wantedItem.key, to: k });
              }
              k++;
            } else if (simulateItem && simulateItem.key) {
              removes.push(remove(simulate, simulateIndex, simulateItem.key));
            }
          } else {
            simulateIndex++;
            k++;
          }
        }
        while (simulateIndex < simulate.length) {
          simulateItem = simulate[simulateIndex];
          removes.push(remove(simulate, simulateIndex, simulateItem && simulateItem.key));
        }
        if (removes.length === deletedItems && !inserts.length) {
          return {
            children: newChildren,
            moves: null
          };
        }
        return {
          children: newChildren,
          moves: {
            removes,
            inserts
          }
        };
      }
      function remove(arr, index2, key) {
        arr.splice(index2, 1);
        return {
          from: index2,
          key
        };
      }
      function keyIndex(children) {
        var keys = {};
        var free = [];
        var length4 = children.length;
        for (var i2 = 0; i2 < length4; i2++) {
          var child = children[i2];
          if (child.key) {
            keys[child.key] = i2;
          } else {
            free.push(i2);
          }
        }
        return {
          keys,
          // A hash of key name to index
          free
          // An array of unkeyed item indices
        };
      }
      function appendPatch(apply2, patch4) {
        if (apply2) {
          if (isArray2(apply2)) {
            apply2.push(patch4);
          } else {
            apply2 = [apply2, patch4];
          }
          return apply2;
        } else {
          return patch4;
        }
      }
    }
  });

  // node_modules/virtual-dom/diff.js
  var require_diff2 = __commonJS({
    "node_modules/virtual-dom/diff.js"(exports, module) {
      var diff2 = require_diff();
      module.exports = diff2;
    }
  });

  // (disabled):node_modules/min-document/index.js
  var require_min_document = __commonJS({
    "(disabled):node_modules/min-document/index.js"() {
    }
  });

  // node_modules/global/document.js
  var require_document = __commonJS({
    "node_modules/global/document.js"(exports, module) {
      var topLevel = typeof global !== "undefined" ? global : typeof window !== "undefined" ? window : {};
      var minDoc = require_min_document();
      var doccy;
      if (typeof document !== "undefined") {
        doccy = document;
      } else {
        doccy = topLevel["__GLOBAL_DOCUMENT_CACHE@4"];
        if (!doccy) {
          doccy = topLevel["__GLOBAL_DOCUMENT_CACHE@4"] = minDoc;
        }
      }
      module.exports = doccy;
    }
  });

  // node_modules/virtual-dom/vdom/apply-properties.js
  var require_apply_properties = __commonJS({
    "node_modules/virtual-dom/vdom/apply-properties.js"(exports, module) {
      var isObject = require_is_object();
      var isHook = require_is_vhook();
      module.exports = applyProperties;
      function applyProperties(node, props, previous) {
        for (var propName in props) {
          var propValue = props[propName];
          if (propValue === void 0) {
            removeProperty(node, propName, propValue, previous);
          } else if (isHook(propValue)) {
            removeProperty(node, propName, propValue, previous);
            if (propValue.hook) {
              propValue.hook(
                node,
                propName,
                previous ? previous[propName] : void 0
              );
            }
          } else {
            if (isObject(propValue)) {
              patchObject(node, props, previous, propName, propValue);
            } else {
              node[propName] = propValue;
            }
          }
        }
      }
      function removeProperty(node, propName, propValue, previous) {
        if (previous) {
          var previousValue = previous[propName];
          if (!isHook(previousValue)) {
            if (propName === "attributes") {
              for (var attrName in previousValue) {
                node.removeAttribute(attrName);
              }
            } else if (propName === "style") {
              for (var i2 in previousValue) {
                node.style[i2] = "";
              }
            } else if (typeof previousValue === "string") {
              node[propName] = "";
            } else {
              node[propName] = null;
            }
          } else if (previousValue.unhook) {
            previousValue.unhook(node, propName, propValue);
          }
        }
      }
      function patchObject(node, props, previous, propName, propValue) {
        var previousValue = previous ? previous[propName] : void 0;
        if (propName === "attributes") {
          for (var attrName in propValue) {
            var attrValue = propValue[attrName];
            if (attrValue === void 0) {
              node.removeAttribute(attrName);
            } else {
              node.setAttribute(attrName, attrValue);
            }
          }
          return;
        }
        if (previousValue && isObject(previousValue) && getPrototype(previousValue) !== getPrototype(propValue)) {
          node[propName] = propValue;
          return;
        }
        if (!isObject(node[propName])) {
          node[propName] = {};
        }
        var replacer = propName === "style" ? "" : void 0;
        for (var k in propValue) {
          var value = propValue[k];
          node[propName][k] = value === void 0 ? replacer : value;
        }
      }
      function getPrototype(value) {
        if (Object.getPrototypeOf) {
          return Object.getPrototypeOf(value);
        } else if (value.__proto__) {
          return value.__proto__;
        } else if (value.constructor) {
          return value.constructor.prototype;
        }
      }
    }
  });

  // node_modules/virtual-dom/vdom/create-element.js
  var require_create_element = __commonJS({
    "node_modules/virtual-dom/vdom/create-element.js"(exports, module) {
      var document2 = require_document();
      var applyProperties = require_apply_properties();
      var isVNode = require_is_vnode();
      var isVText = require_is_vtext();
      var isWidget = require_is_widget();
      var handleThunk = require_handle_thunk();
      module.exports = createElement2;
      function createElement2(vnode, opts) {
        var doc = opts ? opts.document || document2 : document2;
        var warn = opts ? opts.warn : null;
        vnode = handleThunk(vnode).a;
        if (isWidget(vnode)) {
          return vnode.init();
        } else if (isVText(vnode)) {
          return doc.createTextNode(vnode.text);
        } else if (!isVNode(vnode)) {
          if (warn) {
            warn("Item is not a valid virtual dom node", vnode);
          }
          return null;
        }
        var node = vnode.namespace === null ? doc.createElement(vnode.tagName) : doc.createElementNS(vnode.namespace, vnode.tagName);
        var props = vnode.properties;
        applyProperties(node, props);
        var children = vnode.children;
        for (var i2 = 0; i2 < children.length; i2++) {
          var childNode = createElement2(children[i2], opts);
          if (childNode) {
            node.appendChild(childNode);
          }
        }
        return node;
      }
    }
  });

  // node_modules/virtual-dom/vdom/dom-index.js
  var require_dom_index = __commonJS({
    "node_modules/virtual-dom/vdom/dom-index.js"(exports, module) {
      var noChild = {};
      module.exports = domIndex;
      function domIndex(rootNode, tree, indices, nodes) {
        if (!indices || indices.length === 0) {
          return {};
        } else {
          indices.sort(ascending);
          return recurse(rootNode, tree, indices, nodes, 0);
        }
      }
      function recurse(rootNode, tree, indices, nodes, rootIndex) {
        nodes = nodes || {};
        if (rootNode) {
          if (indexInRange(indices, rootIndex, rootIndex)) {
            nodes[rootIndex] = rootNode;
          }
          var vChildren = tree.children;
          if (vChildren) {
            var childNodes = rootNode.childNodes;
            for (var i2 = 0; i2 < tree.children.length; i2++) {
              rootIndex += 1;
              var vChild = vChildren[i2] || noChild;
              var nextIndex = rootIndex + (vChild.count || 0);
              if (indexInRange(indices, rootIndex, nextIndex)) {
                recurse(childNodes[i2], vChild, indices, nodes, rootIndex);
              }
              rootIndex = nextIndex;
            }
          }
        }
        return nodes;
      }
      function indexInRange(indices, left, right) {
        if (indices.length === 0) {
          return false;
        }
        var minIndex = 0;
        var maxIndex = indices.length - 1;
        var currentIndex;
        var currentItem;
        while (minIndex <= maxIndex) {
          currentIndex = (maxIndex + minIndex) / 2 >> 0;
          currentItem = indices[currentIndex];
          if (minIndex === maxIndex) {
            return currentItem >= left && currentItem <= right;
          } else if (currentItem < left) {
            minIndex = currentIndex + 1;
          } else if (currentItem > right) {
            maxIndex = currentIndex - 1;
          } else {
            return true;
          }
        }
        return false;
      }
      function ascending(a2, b2) {
        return a2 > b2 ? 1 : -1;
      }
    }
  });

  // node_modules/virtual-dom/vdom/update-widget.js
  var require_update_widget = __commonJS({
    "node_modules/virtual-dom/vdom/update-widget.js"(exports, module) {
      var isWidget = require_is_widget();
      module.exports = updateWidget;
      function updateWidget(a2, b2) {
        if (isWidget(a2) && isWidget(b2)) {
          if ("name" in a2 && "name" in b2) {
            return a2.id === b2.id;
          } else {
            return a2.init === b2.init;
          }
        }
        return false;
      }
    }
  });

  // node_modules/virtual-dom/vdom/patch-op.js
  var require_patch_op = __commonJS({
    "node_modules/virtual-dom/vdom/patch-op.js"(exports, module) {
      var applyProperties = require_apply_properties();
      var isWidget = require_is_widget();
      var VPatch = require_vpatch();
      var updateWidget = require_update_widget();
      module.exports = applyPatch;
      function applyPatch(vpatch, domNode, renderOptions) {
        var type = vpatch.type;
        var vNode = vpatch.vNode;
        var patch4 = vpatch.patch;
        switch (type) {
          case VPatch.REMOVE:
            return removeNode(domNode, vNode);
          case VPatch.INSERT:
            return insertNode(domNode, patch4, renderOptions);
          case VPatch.VTEXT:
            return stringPatch(domNode, vNode, patch4, renderOptions);
          case VPatch.WIDGET:
            return widgetPatch(domNode, vNode, patch4, renderOptions);
          case VPatch.VNODE:
            return vNodePatch(domNode, vNode, patch4, renderOptions);
          case VPatch.ORDER:
            reorderChildren(domNode, patch4);
            return domNode;
          case VPatch.PROPS:
            applyProperties(domNode, patch4, vNode.properties);
            return domNode;
          case VPatch.THUNK:
            return replaceRoot(
              domNode,
              renderOptions.patch(domNode, patch4, renderOptions)
            );
          default:
            return domNode;
        }
      }
      function removeNode(domNode, vNode) {
        var parentNode = domNode.parentNode;
        if (parentNode) {
          parentNode.removeChild(domNode);
        }
        destroyWidget(domNode, vNode);
        return null;
      }
      function insertNode(parentNode, vNode, renderOptions) {
        var newNode = renderOptions.render(vNode, renderOptions);
        if (parentNode) {
          parentNode.appendChild(newNode);
        }
        return parentNode;
      }
      function stringPatch(domNode, leftVNode, vText, renderOptions) {
        var newNode;
        if (domNode.nodeType === 3) {
          domNode.replaceData(0, domNode.length, vText.text);
          newNode = domNode;
        } else {
          var parentNode = domNode.parentNode;
          newNode = renderOptions.render(vText, renderOptions);
          if (parentNode && newNode !== domNode) {
            parentNode.replaceChild(newNode, domNode);
          }
        }
        return newNode;
      }
      function widgetPatch(domNode, leftVNode, widget, renderOptions) {
        var updating = updateWidget(leftVNode, widget);
        var newNode;
        if (updating) {
          newNode = widget.update(leftVNode, domNode) || domNode;
        } else {
          newNode = renderOptions.render(widget, renderOptions);
        }
        var parentNode = domNode.parentNode;
        if (parentNode && newNode !== domNode) {
          parentNode.replaceChild(newNode, domNode);
        }
        if (!updating) {
          destroyWidget(domNode, leftVNode);
        }
        return newNode;
      }
      function vNodePatch(domNode, leftVNode, vNode, renderOptions) {
        var parentNode = domNode.parentNode;
        var newNode = renderOptions.render(vNode, renderOptions);
        if (parentNode && newNode !== domNode) {
          parentNode.replaceChild(newNode, domNode);
        }
        return newNode;
      }
      function destroyWidget(domNode, w) {
        if (typeof w.destroy === "function" && isWidget(w)) {
          w.destroy(domNode);
        }
      }
      function reorderChildren(domNode, moves) {
        var childNodes = domNode.childNodes;
        var keyMap = {};
        var node;
        var remove;
        var insert2;
        for (var i2 = 0; i2 < moves.removes.length; i2++) {
          remove = moves.removes[i2];
          node = childNodes[remove.from];
          if (remove.key) {
            keyMap[remove.key] = node;
          }
          domNode.removeChild(node);
        }
        var length4 = childNodes.length;
        for (var j = 0; j < moves.inserts.length; j++) {
          insert2 = moves.inserts[j];
          node = keyMap[insert2.key];
          domNode.insertBefore(node, insert2.to >= length4++ ? null : childNodes[insert2.to]);
        }
      }
      function replaceRoot(oldRoot, newRoot) {
        if (oldRoot && newRoot && oldRoot !== newRoot && oldRoot.parentNode) {
          oldRoot.parentNode.replaceChild(newRoot, oldRoot);
        }
        return newRoot;
      }
    }
  });

  // node_modules/virtual-dom/vdom/patch.js
  var require_patch = __commonJS({
    "node_modules/virtual-dom/vdom/patch.js"(exports, module) {
      var document2 = require_document();
      var isArray2 = require_x_is_array();
      var render3 = require_create_element();
      var domIndex = require_dom_index();
      var patchOp = require_patch_op();
      module.exports = patch4;
      function patch4(rootNode, patches, renderOptions) {
        renderOptions = renderOptions || {};
        renderOptions.patch = renderOptions.patch && renderOptions.patch !== patch4 ? renderOptions.patch : patchRecursive;
        renderOptions.render = renderOptions.render || render3;
        return renderOptions.patch(rootNode, patches, renderOptions);
      }
      function patchRecursive(rootNode, patches, renderOptions) {
        var indices = patchIndices(patches);
        if (indices.length === 0) {
          return rootNode;
        }
        var index2 = domIndex(rootNode, patches.a, indices);
        var ownerDocument = rootNode.ownerDocument;
        if (!renderOptions.document && ownerDocument !== document2) {
          renderOptions.document = ownerDocument;
        }
        for (var i2 = 0; i2 < indices.length; i2++) {
          var nodeIndex = indices[i2];
          rootNode = applyPatch(
            rootNode,
            index2[nodeIndex],
            patches[nodeIndex],
            renderOptions
          );
        }
        return rootNode;
      }
      function applyPatch(rootNode, domNode, patchList, renderOptions) {
        if (!domNode) {
          return rootNode;
        }
        var newNode;
        if (isArray2(patchList)) {
          for (var i2 = 0; i2 < patchList.length; i2++) {
            newNode = patchOp(patchList[i2], domNode, renderOptions);
            if (domNode === rootNode) {
              rootNode = newNode;
            }
          }
        } else {
          newNode = patchOp(patchList, domNode, renderOptions);
          if (domNode === rootNode) {
            rootNode = newNode;
          }
        }
        return rootNode;
      }
      function patchIndices(patches) {
        var indices = [];
        for (var key in patches) {
          if (key !== "a") {
            indices.push(Number(key));
          }
        }
        return indices;
      }
    }
  });

  // node_modules/virtual-dom/patch.js
  var require_patch2 = __commonJS({
    "node_modules/virtual-dom/patch.js"(exports, module) {
      var patch4 = require_patch();
      module.exports = patch4;
    }
  });

  // node_modules/virtual-dom/create-element.js
  var require_create_element2 = __commonJS({
    "node_modules/virtual-dom/create-element.js"(exports, module) {
      var createElement2 = require_create_element();
      module.exports = createElement2;
    }
  });

  // output/Data.Functor/foreign.js
  var arrayMap = function(f) {
    return function(arr) {
      var l = arr.length;
      var result = new Array(l);
      for (var i2 = 0; i2 < l; i2++) {
        result[i2] = f(arr[i2]);
      }
      return result;
    };
  };

  // output/Control.Semigroupoid/index.js
  var semigroupoidFn = {
    compose: function(f) {
      return function(g) {
        return function(x) {
          return f(g(x));
        };
      };
    }
  };

  // output/Control.Category/index.js
  var identity = function(dict) {
    return dict.identity;
  };
  var categoryFn = {
    identity: function(x) {
      return x;
    },
    Semigroupoid0: function() {
      return semigroupoidFn;
    }
  };

  // output/Data.Boolean/index.js
  var otherwise = true;

  // output/Data.Function/index.js
  var flip = function(f) {
    return function(b2) {
      return function(a2) {
        return f(a2)(b2);
      };
    };
  };
  var $$const = function(a2) {
    return function(v) {
      return a2;
    };
  };

  // output/Data.Unit/foreign.js
  var unit = void 0;

  // output/Type.Proxy/index.js
  var $$Proxy = /* @__PURE__ */ function() {
    function $$Proxy2() {
    }
    ;
    $$Proxy2.value = new $$Proxy2();
    return $$Proxy2;
  }();

  // output/Data.Functor/index.js
  var map = function(dict) {
    return dict.map;
  };
  var mapFlipped = function(dictFunctor) {
    var map1 = map(dictFunctor);
    return function(fa) {
      return function(f) {
        return map1(f)(fa);
      };
    };
  };
  var $$void = function(dictFunctor) {
    return map(dictFunctor)($$const(unit));
  };
  var voidRight = function(dictFunctor) {
    var map1 = map(dictFunctor);
    return function(x) {
      return map1($$const(x));
    };
  };
  var functorArray = {
    map: arrayMap
  };

  // output/Data.Semigroup/foreign.js
  var concatString = function(s1) {
    return function(s2) {
      return s1 + s2;
    };
  };
  var concatArray = function(xs) {
    return function(ys) {
      if (xs.length === 0)
        return ys;
      if (ys.length === 0)
        return xs;
      return xs.concat(ys);
    };
  };

  // output/Data.Semigroup/index.js
  var semigroupUnit = {
    append: function(v) {
      return function(v1) {
        return unit;
      };
    }
  };
  var semigroupString = {
    append: concatString
  };
  var semigroupArray = {
    append: concatArray
  };
  var append = function(dict) {
    return dict.append;
  };

  // output/Control.Alt/index.js
  var altArray = {
    alt: /* @__PURE__ */ append(semigroupArray),
    Functor0: function() {
      return functorArray;
    }
  };
  var alt = function(dict) {
    return dict.alt;
  };

  // output/Control.Apply/foreign.js
  var arrayApply = function(fs) {
    return function(xs) {
      var l = fs.length;
      var k = xs.length;
      var result = new Array(l * k);
      var n = 0;
      for (var i2 = 0; i2 < l; i2++) {
        var f = fs[i2];
        for (var j = 0; j < k; j++) {
          result[n++] = f(xs[j]);
        }
      }
      return result;
    };
  };

  // output/Control.Apply/index.js
  var identity2 = /* @__PURE__ */ identity(categoryFn);
  var applyArray = {
    apply: arrayApply,
    Functor0: function() {
      return functorArray;
    }
  };
  var apply = function(dict) {
    return dict.apply;
  };
  var applySecond = function(dictApply) {
    var apply1 = apply(dictApply);
    var map6 = map(dictApply.Functor0());
    return function(a2) {
      return function(b2) {
        return apply1(map6($$const(identity2))(a2))(b2);
      };
    };
  };
  var lift2 = function(dictApply) {
    var apply1 = apply(dictApply);
    var map6 = map(dictApply.Functor0());
    return function(f) {
      return function(a2) {
        return function(b2) {
          return apply1(map6(f)(a2))(b2);
        };
      };
    };
  };

  // output/Control.Applicative/index.js
  var pure = function(dict) {
    return dict.pure;
  };
  var liftA1 = function(dictApplicative) {
    var apply2 = apply(dictApplicative.Apply0());
    var pure12 = pure(dictApplicative);
    return function(f) {
      return function(a2) {
        return apply2(pure12(f))(a2);
      };
    };
  };
  var applicativeArray = {
    pure: function(x) {
      return [x];
    },
    Apply0: function() {
      return applyArray;
    }
  };

  // output/Control.Plus/index.js
  var plusArray = {
    empty: [],
    Alt0: function() {
      return altArray;
    }
  };
  var empty = function(dict) {
    return dict.empty;
  };

  // output/Control.Alternative/index.js
  var guard = function(dictAlternative) {
    var pure5 = pure(dictAlternative.Applicative0());
    var empty4 = empty(dictAlternative.Plus1());
    return function(v) {
      if (v) {
        return pure5(unit);
      }
      ;
      if (!v) {
        return empty4;
      }
      ;
      throw new Error("Failed pattern match at Control.Alternative (line 48, column 1 - line 48, column 54): " + [v.constructor.name]);
    };
  };
  var alternativeArray = {
    Applicative0: function() {
      return applicativeArray;
    },
    Plus1: function() {
      return plusArray;
    }
  };

  // output/Control.Bind/foreign.js
  var arrayBind = function(arr) {
    return function(f) {
      var result = [];
      for (var i2 = 0, l = arr.length; i2 < l; i2++) {
        Array.prototype.push.apply(result, f(arr[i2]));
      }
      return result;
    };
  };

  // output/Control.Bind/index.js
  var discard = function(dict) {
    return dict.discard;
  };
  var bindArray = {
    bind: arrayBind,
    Apply0: function() {
      return applyArray;
    }
  };
  var bind = function(dict) {
    return dict.bind;
  };
  var bindFlipped = function(dictBind) {
    return flip(bind(dictBind));
  };
  var discardUnit = {
    discard: function(dictBind) {
      return bind(dictBind);
    }
  };

  // output/Data.Array/foreign.js
  var range = function(start) {
    return function(end) {
      var step = start > end ? -1 : 1;
      var result = new Array(step * (end - start) + 1);
      var i2 = start, n = 0;
      while (i2 !== end) {
        result[n++] = i2;
        i2 += step;
      }
      result[n] = i2;
      return result;
    };
  };
  var replicateFill = function(count) {
    return function(value) {
      if (count < 1) {
        return [];
      }
      var result = new Array(count);
      return result.fill(value);
    };
  };
  var replicatePolyfill = function(count) {
    return function(value) {
      var result = [];
      var n = 0;
      for (var i2 = 0; i2 < count; i2++) {
        result[n++] = value;
      }
      return result;
    };
  };
  var replicate = typeof Array.prototype.fill === "function" ? replicateFill : replicatePolyfill;
  var fromFoldableImpl = function() {
    function Cons2(head, tail) {
      this.head = head;
      this.tail = tail;
    }
    var emptyList = {};
    function curryCons(head) {
      return function(tail) {
        return new Cons2(head, tail);
      };
    }
    function listToArray(list) {
      var result = [];
      var count = 0;
      var xs = list;
      while (xs !== emptyList) {
        result[count++] = xs.head;
        xs = xs.tail;
      }
      return result;
    }
    return function(foldr4) {
      return function(xs) {
        return listToArray(foldr4(curryCons)(emptyList)(xs));
      };
    };
  }();
  var sortByImpl = function() {
    function mergeFromTo(compare2, fromOrdering, xs1, xs2, from3, to) {
      var mid;
      var i2;
      var j;
      var k;
      var x;
      var y;
      var c;
      mid = from3 + (to - from3 >> 1);
      if (mid - from3 > 1)
        mergeFromTo(compare2, fromOrdering, xs2, xs1, from3, mid);
      if (to - mid > 1)
        mergeFromTo(compare2, fromOrdering, xs2, xs1, mid, to);
      i2 = from3;
      j = mid;
      k = from3;
      while (i2 < mid && j < to) {
        x = xs2[i2];
        y = xs2[j];
        c = fromOrdering(compare2(x)(y));
        if (c > 0) {
          xs1[k++] = y;
          ++j;
        } else {
          xs1[k++] = x;
          ++i2;
        }
      }
      while (i2 < mid) {
        xs1[k++] = xs2[i2++];
      }
      while (j < to) {
        xs1[k++] = xs2[j++];
      }
    }
    return function(compare2) {
      return function(fromOrdering) {
        return function(xs) {
          var out;
          if (xs.length < 2)
            return xs;
          out = xs.slice(0);
          mergeFromTo(compare2, fromOrdering, out, xs.slice(0), 0, xs.length);
          return out;
        };
      };
    };
  }();

  // output/Control.Monad/index.js
  var ap = function(dictMonad) {
    var bind5 = bind(dictMonad.Bind1());
    var pure5 = pure(dictMonad.Applicative0());
    return function(f) {
      return function(a2) {
        return bind5(f)(function(f$prime) {
          return bind5(a2)(function(a$prime) {
            return pure5(f$prime(a$prime));
          });
        });
      };
    };
  };

  // output/Data.Bounded/foreign.js
  var topChar = String.fromCharCode(65535);
  var bottomChar = String.fromCharCode(0);
  var topNumber = Number.POSITIVE_INFINITY;
  var bottomNumber = Number.NEGATIVE_INFINITY;

  // output/Data.Show/foreign.js
  var showIntImpl = function(n) {
    return n.toString();
  };

  // output/Data.Show/index.js
  var showInt = {
    show: showIntImpl
  };
  var show = function(dict) {
    return dict.show;
  };

  // output/Data.Maybe/index.js
  var Nothing = /* @__PURE__ */ function() {
    function Nothing2() {
    }
    ;
    Nothing2.value = new Nothing2();
    return Nothing2;
  }();
  var Just = /* @__PURE__ */ function() {
    function Just2(value0) {
      this.value0 = value0;
    }
    ;
    Just2.create = function(value0) {
      return new Just2(value0);
    };
    return Just2;
  }();
  var fromJust = function() {
    return function(v) {
      if (v instanceof Just) {
        return v.value0;
      }
      ;
      throw new Error("Failed pattern match at Data.Maybe (line 288, column 1 - line 288, column 46): " + [v.constructor.name]);
    };
  };

  // output/Data.Either/index.js
  var Left = /* @__PURE__ */ function() {
    function Left2(value0) {
      this.value0 = value0;
    }
    ;
    Left2.create = function(value0) {
      return new Left2(value0);
    };
    return Left2;
  }();
  var Right = /* @__PURE__ */ function() {
    function Right2(value0) {
      this.value0 = value0;
    }
    ;
    Right2.create = function(value0) {
      return new Right2(value0);
    };
    return Right2;
  }();
  var functorEither = {
    map: function(f) {
      return function(m) {
        if (m instanceof Left) {
          return new Left(m.value0);
        }
        ;
        if (m instanceof Right) {
          return new Right(f(m.value0));
        }
        ;
        throw new Error("Failed pattern match at Data.Either (line 0, column 0 - line 0, column 0): " + [m.constructor.name]);
      };
    }
  };
  var either = function(v) {
    return function(v1) {
      return function(v2) {
        if (v2 instanceof Left) {
          return v(v2.value0);
        }
        ;
        if (v2 instanceof Right) {
          return v1(v2.value0);
        }
        ;
        throw new Error("Failed pattern match at Data.Either (line 208, column 1 - line 208, column 64): " + [v.constructor.name, v1.constructor.name, v2.constructor.name]);
      };
    };
  };

  // output/Data.Identity/index.js
  var Identity = function(x) {
    return x;
  };
  var functorIdentity = {
    map: function(f) {
      return function(m) {
        return f(m);
      };
    }
  };
  var applyIdentity = {
    apply: function(v) {
      return function(v1) {
        return v(v1);
      };
    },
    Functor0: function() {
      return functorIdentity;
    }
  };
  var bindIdentity = {
    bind: function(v) {
      return function(f) {
        return f(v);
      };
    },
    Apply0: function() {
      return applyIdentity;
    }
  };
  var applicativeIdentity = {
    pure: Identity,
    Apply0: function() {
      return applyIdentity;
    }
  };
  var monadIdentity = {
    Applicative0: function() {
      return applicativeIdentity;
    },
    Bind1: function() {
      return bindIdentity;
    }
  };

  // output/Data.Monoid/index.js
  var monoidUnit = {
    mempty: unit,
    Semigroup0: function() {
      return semigroupUnit;
    }
  };
  var monoidString = {
    mempty: "",
    Semigroup0: function() {
      return semigroupString;
    }
  };
  var mempty = function(dict) {
    return dict.mempty;
  };

  // output/Effect/foreign.js
  var pureE = function(a2) {
    return function() {
      return a2;
    };
  };
  var bindE = function(a2) {
    return function(f) {
      return function() {
        return f(a2())();
      };
    };
  };

  // output/Effect/index.js
  var $runtime_lazy = function(name2, moduleName, init3) {
    var state2 = 0;
    var val;
    return function(lineNumber) {
      if (state2 === 2)
        return val;
      if (state2 === 1)
        throw new ReferenceError(name2 + " was needed before it finished initializing (module " + moduleName + ", line " + lineNumber + ")", moduleName, lineNumber);
      state2 = 1;
      val = init3();
      state2 = 2;
      return val;
    };
  };
  var monadEffect = {
    Applicative0: function() {
      return applicativeEffect;
    },
    Bind1: function() {
      return bindEffect;
    }
  };
  var bindEffect = {
    bind: bindE,
    Apply0: function() {
      return $lazy_applyEffect(0);
    }
  };
  var applicativeEffect = {
    pure: pureE,
    Apply0: function() {
      return $lazy_applyEffect(0);
    }
  };
  var $lazy_functorEffect = /* @__PURE__ */ $runtime_lazy("functorEffect", "Effect", function() {
    return {
      map: liftA1(applicativeEffect)
    };
  });
  var $lazy_applyEffect = /* @__PURE__ */ $runtime_lazy("applyEffect", "Effect", function() {
    return {
      apply: ap(monadEffect),
      Functor0: function() {
        return $lazy_functorEffect(0);
      }
    };
  });
  var functorEffect = /* @__PURE__ */ $lazy_functorEffect(20);
  var applyEffect = /* @__PURE__ */ $lazy_applyEffect(23);
  var lift22 = /* @__PURE__ */ lift2(applyEffect);
  var semigroupEffect = function(dictSemigroup) {
    return {
      append: lift22(append(dictSemigroup))
    };
  };
  var monoidEffect = function(dictMonoid) {
    var semigroupEffect1 = semigroupEffect(dictMonoid.Semigroup0());
    return {
      mempty: pureE(mempty(dictMonoid)),
      Semigroup0: function() {
        return semigroupEffect1;
      }
    };
  };

  // output/Effect.Ref/foreign.js
  var _new = function(val) {
    return function() {
      return { value: val };
    };
  };
  var read = function(ref) {
    return function() {
      return ref.value;
    };
  };
  var write = function(val) {
    return function(ref) {
      return function() {
        ref.value = val;
      };
    };
  };

  // output/Effect.Ref/index.js
  var $$new = _new;

  // output/Data.Array.ST/foreign.js
  var sortByImpl2 = function() {
    function mergeFromTo(compare2, fromOrdering, xs1, xs2, from3, to) {
      var mid;
      var i2;
      var j;
      var k;
      var x;
      var y;
      var c;
      mid = from3 + (to - from3 >> 1);
      if (mid - from3 > 1)
        mergeFromTo(compare2, fromOrdering, xs2, xs1, from3, mid);
      if (to - mid > 1)
        mergeFromTo(compare2, fromOrdering, xs2, xs1, mid, to);
      i2 = from3;
      j = mid;
      k = from3;
      while (i2 < mid && j < to) {
        x = xs2[i2];
        y = xs2[j];
        c = fromOrdering(compare2(x)(y));
        if (c > 0) {
          xs1[k++] = y;
          ++j;
        } else {
          xs1[k++] = x;
          ++i2;
        }
      }
      while (i2 < mid) {
        xs1[k++] = xs2[i2++];
      }
      while (j < to) {
        xs1[k++] = xs2[j++];
      }
    }
    return function(compare2) {
      return function(fromOrdering) {
        return function(xs) {
          return function() {
            if (xs.length < 2)
              return xs;
            mergeFromTo(compare2, fromOrdering, xs, xs.slice(0), 0, xs.length);
            return xs;
          };
        };
      };
    };
  }();

  // output/Data.Foldable/foreign.js
  var foldrArray = function(f) {
    return function(init3) {
      return function(xs) {
        var acc = init3;
        var len = xs.length;
        for (var i2 = len - 1; i2 >= 0; i2--) {
          acc = f(xs[i2])(acc);
        }
        return acc;
      };
    };
  };
  var foldlArray = function(f) {
    return function(init3) {
      return function(xs) {
        var acc = init3;
        var len = xs.length;
        for (var i2 = 0; i2 < len; i2++) {
          acc = f(acc)(xs[i2]);
        }
        return acc;
      };
    };
  };

  // output/Unsafe.Coerce/foreign.js
  var unsafeCoerce2 = function(x) {
    return x;
  };

  // output/Safe.Coerce/index.js
  var coerce = function() {
    return unsafeCoerce2;
  };

  // output/Data.Newtype/index.js
  var coerce2 = /* @__PURE__ */ coerce();
  var unwrap = function() {
    return coerce2;
  };

  // output/Data.Foldable/index.js
  var foldr = function(dict) {
    return dict.foldr;
  };
  var traverse_ = function(dictApplicative) {
    var applySecond2 = applySecond(dictApplicative.Apply0());
    var pure5 = pure(dictApplicative);
    return function(dictFoldable) {
      var foldr22 = foldr(dictFoldable);
      return function(f) {
        return foldr22(function($449) {
          return applySecond2(f($449));
        })(pure5(unit));
      };
    };
  };
  var foldl = function(dict) {
    return dict.foldl;
  };
  var intercalate = function(dictFoldable) {
    var foldl2 = foldl(dictFoldable);
    return function(dictMonoid) {
      var append2 = append(dictMonoid.Semigroup0());
      var mempty5 = mempty(dictMonoid);
      return function(sep) {
        return function(xs) {
          var go = function(v) {
            return function(x) {
              if (v.init) {
                return {
                  init: false,
                  acc: x
                };
              }
              ;
              return {
                init: false,
                acc: append2(v.acc)(append2(sep)(x))
              };
            };
          };
          return foldl2(go)({
            init: true,
            acc: mempty5
          })(xs).acc;
        };
      };
    };
  };
  var foldMapDefaultR = function(dictFoldable) {
    var foldr22 = foldr(dictFoldable);
    return function(dictMonoid) {
      var append2 = append(dictMonoid.Semigroup0());
      var mempty5 = mempty(dictMonoid);
      return function(f) {
        return foldr22(function(x) {
          return function(acc) {
            return append2(f(x))(acc);
          };
        })(mempty5);
      };
    };
  };
  var foldableArray = {
    foldr: foldrArray,
    foldl: foldlArray,
    foldMap: function(dictMonoid) {
      return foldMapDefaultR(foldableArray)(dictMonoid);
    }
  };

  // output/Data.Traversable/foreign.js
  var traverseArrayImpl = function() {
    function array1(a2) {
      return [a2];
    }
    function array2(a2) {
      return function(b2) {
        return [a2, b2];
      };
    }
    function array3(a2) {
      return function(b2) {
        return function(c) {
          return [a2, b2, c];
        };
      };
    }
    function concat2(xs) {
      return function(ys) {
        return xs.concat(ys);
      };
    }
    return function(apply2) {
      return function(map6) {
        return function(pure5) {
          return function(f) {
            return function(array) {
              function go(bot, top2) {
                switch (top2 - bot) {
                  case 0:
                    return pure5([]);
                  case 1:
                    return map6(array1)(f(array[bot]));
                  case 2:
                    return apply2(map6(array2)(f(array[bot])))(f(array[bot + 1]));
                  case 3:
                    return apply2(apply2(map6(array3)(f(array[bot])))(f(array[bot + 1])))(f(array[bot + 2]));
                  default:
                    var pivot = bot + Math.floor((top2 - bot) / 4) * 2;
                    return apply2(map6(concat2)(go(bot, pivot)))(go(pivot, top2));
                }
              }
              return go(0, array.length);
            };
          };
        };
      };
    };
  }();

  // output/Data.Traversable/index.js
  var identity3 = /* @__PURE__ */ identity(categoryFn);
  var traverse = function(dict) {
    return dict.traverse;
  };
  var sequenceDefault = function(dictTraversable) {
    var traverse2 = traverse(dictTraversable);
    return function(dictApplicative) {
      return traverse2(dictApplicative)(identity3);
    };
  };
  var traversableArray = {
    traverse: function(dictApplicative) {
      var Apply0 = dictApplicative.Apply0();
      return traverseArrayImpl(apply(Apply0))(map(Apply0.Functor0()))(pure(dictApplicative));
    },
    sequence: function(dictApplicative) {
      return sequenceDefault(traversableArray)(dictApplicative);
    },
    Functor0: function() {
      return functorArray;
    },
    Foldable1: function() {
      return foldableArray;
    }
  };
  var sequence = function(dict) {
    return dict.sequence;
  };

  // output/Data.Int/index.js
  var even = function(x) {
    return (x & 1) === 0;
  };

  // output/Effect.Aff/foreign.js
  var Aff = function() {
    var EMPTY = {};
    var PURE = "Pure";
    var THROW = "Throw";
    var CATCH = "Catch";
    var SYNC = "Sync";
    var ASYNC = "Async";
    var BIND = "Bind";
    var BRACKET = "Bracket";
    var FORK = "Fork";
    var SEQ = "Sequential";
    var MAP = "Map";
    var APPLY = "Apply";
    var ALT = "Alt";
    var CONS = "Cons";
    var RESUME = "Resume";
    var RELEASE = "Release";
    var FINALIZER = "Finalizer";
    var FINALIZED = "Finalized";
    var FORKED = "Forked";
    var FIBER = "Fiber";
    var THUNK = "Thunk";
    function Aff2(tag, _1, _2, _3) {
      this.tag = tag;
      this._1 = _1;
      this._2 = _2;
      this._3 = _3;
    }
    function AffCtr(tag) {
      var fn = function(_1, _2, _3) {
        return new Aff2(tag, _1, _2, _3);
      };
      fn.tag = tag;
      return fn;
    }
    function nonCanceler2(error2) {
      return new Aff2(PURE, void 0);
    }
    function runEff(eff) {
      try {
        eff();
      } catch (error2) {
        setTimeout(function() {
          throw error2;
        }, 0);
      }
    }
    function runSync(left, right, eff) {
      try {
        return right(eff());
      } catch (error2) {
        return left(error2);
      }
    }
    function runAsync(left, eff, k) {
      try {
        return eff(k)();
      } catch (error2) {
        k(left(error2))();
        return nonCanceler2;
      }
    }
    var Scheduler = function() {
      var limit = 1024;
      var size = 0;
      var ix = 0;
      var queue = new Array(limit);
      var draining = false;
      function drain() {
        var thunk;
        draining = true;
        while (size !== 0) {
          size--;
          thunk = queue[ix];
          queue[ix] = void 0;
          ix = (ix + 1) % limit;
          thunk();
        }
        draining = false;
      }
      return {
        isDraining: function() {
          return draining;
        },
        enqueue: function(cb) {
          var i2, tmp;
          if (size === limit) {
            tmp = draining;
            drain();
            draining = tmp;
          }
          queue[(ix + size) % limit] = cb;
          size++;
          if (!draining) {
            drain();
          }
        }
      };
    }();
    function Supervisor(util) {
      var fibers = {};
      var fiberId = 0;
      var count = 0;
      return {
        register: function(fiber) {
          var fid = fiberId++;
          fiber.onComplete({
            rethrow: true,
            handler: function(result) {
              return function() {
                count--;
                delete fibers[fid];
              };
            }
          })();
          fibers[fid] = fiber;
          count++;
        },
        isEmpty: function() {
          return count === 0;
        },
        killAll: function(killError, cb) {
          return function() {
            if (count === 0) {
              return cb();
            }
            var killCount = 0;
            var kills = {};
            function kill(fid) {
              kills[fid] = fibers[fid].kill(killError, function(result) {
                return function() {
                  delete kills[fid];
                  killCount--;
                  if (util.isLeft(result) && util.fromLeft(result)) {
                    setTimeout(function() {
                      throw util.fromLeft(result);
                    }, 0);
                  }
                  if (killCount === 0) {
                    cb();
                  }
                };
              })();
            }
            for (var k in fibers) {
              if (fibers.hasOwnProperty(k)) {
                killCount++;
                kill(k);
              }
            }
            fibers = {};
            fiberId = 0;
            count = 0;
            return function(error2) {
              return new Aff2(SYNC, function() {
                for (var k2 in kills) {
                  if (kills.hasOwnProperty(k2)) {
                    kills[k2]();
                  }
                }
              });
            };
          };
        }
      };
    }
    var SUSPENDED = 0;
    var CONTINUE = 1;
    var STEP_BIND = 2;
    var STEP_RESULT = 3;
    var PENDING = 4;
    var RETURN = 5;
    var COMPLETED = 6;
    function Fiber(util, supervisor, aff) {
      var runTick = 0;
      var status2 = SUSPENDED;
      var step = aff;
      var fail2 = null;
      var interrupt = null;
      var bhead = null;
      var btail = null;
      var attempts = null;
      var bracketCount = 0;
      var joinId = 0;
      var joins = null;
      var rethrow = true;
      function run3(localRunTick) {
        var tmp, result, attempt;
        while (true) {
          tmp = null;
          result = null;
          attempt = null;
          switch (status2) {
            case STEP_BIND:
              status2 = CONTINUE;
              try {
                step = bhead(step);
                if (btail === null) {
                  bhead = null;
                } else {
                  bhead = btail._1;
                  btail = btail._2;
                }
              } catch (e) {
                status2 = RETURN;
                fail2 = util.left(e);
                step = null;
              }
              break;
            case STEP_RESULT:
              if (util.isLeft(step)) {
                status2 = RETURN;
                fail2 = step;
                step = null;
              } else if (bhead === null) {
                status2 = RETURN;
              } else {
                status2 = STEP_BIND;
                step = util.fromRight(step);
              }
              break;
            case CONTINUE:
              switch (step.tag) {
                case BIND:
                  if (bhead) {
                    btail = new Aff2(CONS, bhead, btail);
                  }
                  bhead = step._2;
                  status2 = CONTINUE;
                  step = step._1;
                  break;
                case PURE:
                  if (bhead === null) {
                    status2 = RETURN;
                    step = util.right(step._1);
                  } else {
                    status2 = STEP_BIND;
                    step = step._1;
                  }
                  break;
                case SYNC:
                  status2 = STEP_RESULT;
                  step = runSync(util.left, util.right, step._1);
                  break;
                case ASYNC:
                  status2 = PENDING;
                  step = runAsync(util.left, step._1, function(result2) {
                    return function() {
                      if (runTick !== localRunTick) {
                        return;
                      }
                      runTick++;
                      Scheduler.enqueue(function() {
                        if (runTick !== localRunTick + 1) {
                          return;
                        }
                        status2 = STEP_RESULT;
                        step = result2;
                        run3(runTick);
                      });
                    };
                  });
                  return;
                case THROW:
                  status2 = RETURN;
                  fail2 = util.left(step._1);
                  step = null;
                  break;
                case CATCH:
                  if (bhead === null) {
                    attempts = new Aff2(CONS, step, attempts, interrupt);
                  } else {
                    attempts = new Aff2(CONS, step, new Aff2(CONS, new Aff2(RESUME, bhead, btail), attempts, interrupt), interrupt);
                  }
                  bhead = null;
                  btail = null;
                  status2 = CONTINUE;
                  step = step._1;
                  break;
                case BRACKET:
                  bracketCount++;
                  if (bhead === null) {
                    attempts = new Aff2(CONS, step, attempts, interrupt);
                  } else {
                    attempts = new Aff2(CONS, step, new Aff2(CONS, new Aff2(RESUME, bhead, btail), attempts, interrupt), interrupt);
                  }
                  bhead = null;
                  btail = null;
                  status2 = CONTINUE;
                  step = step._1;
                  break;
                case FORK:
                  status2 = STEP_RESULT;
                  tmp = Fiber(util, supervisor, step._2);
                  if (supervisor) {
                    supervisor.register(tmp);
                  }
                  if (step._1) {
                    tmp.run();
                  }
                  step = util.right(tmp);
                  break;
                case SEQ:
                  status2 = CONTINUE;
                  step = sequential2(util, supervisor, step._1);
                  break;
              }
              break;
            case RETURN:
              bhead = null;
              btail = null;
              if (attempts === null) {
                status2 = COMPLETED;
                step = interrupt || fail2 || step;
              } else {
                tmp = attempts._3;
                attempt = attempts._1;
                attempts = attempts._2;
                switch (attempt.tag) {
                  case CATCH:
                    if (interrupt && interrupt !== tmp && bracketCount === 0) {
                      status2 = RETURN;
                    } else if (fail2) {
                      status2 = CONTINUE;
                      step = attempt._2(util.fromLeft(fail2));
                      fail2 = null;
                    }
                    break;
                  case RESUME:
                    if (interrupt && interrupt !== tmp && bracketCount === 0 || fail2) {
                      status2 = RETURN;
                    } else {
                      bhead = attempt._1;
                      btail = attempt._2;
                      status2 = STEP_BIND;
                      step = util.fromRight(step);
                    }
                    break;
                  case BRACKET:
                    bracketCount--;
                    if (fail2 === null) {
                      result = util.fromRight(step);
                      attempts = new Aff2(CONS, new Aff2(RELEASE, attempt._2, result), attempts, tmp);
                      if (interrupt === tmp || bracketCount > 0) {
                        status2 = CONTINUE;
                        step = attempt._3(result);
                      }
                    }
                    break;
                  case RELEASE:
                    attempts = new Aff2(CONS, new Aff2(FINALIZED, step, fail2), attempts, interrupt);
                    status2 = CONTINUE;
                    if (interrupt && interrupt !== tmp && bracketCount === 0) {
                      step = attempt._1.killed(util.fromLeft(interrupt))(attempt._2);
                    } else if (fail2) {
                      step = attempt._1.failed(util.fromLeft(fail2))(attempt._2);
                    } else {
                      step = attempt._1.completed(util.fromRight(step))(attempt._2);
                    }
                    fail2 = null;
                    bracketCount++;
                    break;
                  case FINALIZER:
                    bracketCount++;
                    attempts = new Aff2(CONS, new Aff2(FINALIZED, step, fail2), attempts, interrupt);
                    status2 = CONTINUE;
                    step = attempt._1;
                    break;
                  case FINALIZED:
                    bracketCount--;
                    status2 = RETURN;
                    step = attempt._1;
                    fail2 = attempt._2;
                    break;
                }
              }
              break;
            case COMPLETED:
              for (var k in joins) {
                if (joins.hasOwnProperty(k)) {
                  rethrow = rethrow && joins[k].rethrow;
                  runEff(joins[k].handler(step));
                }
              }
              joins = null;
              if (interrupt && fail2) {
                setTimeout(function() {
                  throw util.fromLeft(fail2);
                }, 0);
              } else if (util.isLeft(step) && rethrow) {
                setTimeout(function() {
                  if (rethrow) {
                    throw util.fromLeft(step);
                  }
                }, 0);
              }
              return;
            case SUSPENDED:
              status2 = CONTINUE;
              break;
            case PENDING:
              return;
          }
        }
      }
      function onComplete(join3) {
        return function() {
          if (status2 === COMPLETED) {
            rethrow = rethrow && join3.rethrow;
            join3.handler(step)();
            return function() {
            };
          }
          var jid = joinId++;
          joins = joins || {};
          joins[jid] = join3;
          return function() {
            if (joins !== null) {
              delete joins[jid];
            }
          };
        };
      }
      function kill(error2, cb) {
        return function() {
          if (status2 === COMPLETED) {
            cb(util.right(void 0))();
            return function() {
            };
          }
          var canceler = onComplete({
            rethrow: false,
            handler: function() {
              return cb(util.right(void 0));
            }
          })();
          switch (status2) {
            case SUSPENDED:
              interrupt = util.left(error2);
              status2 = COMPLETED;
              step = interrupt;
              run3(runTick);
              break;
            case PENDING:
              if (interrupt === null) {
                interrupt = util.left(error2);
              }
              if (bracketCount === 0) {
                if (status2 === PENDING) {
                  attempts = new Aff2(CONS, new Aff2(FINALIZER, step(error2)), attempts, interrupt);
                }
                status2 = RETURN;
                step = null;
                fail2 = null;
                run3(++runTick);
              }
              break;
            default:
              if (interrupt === null) {
                interrupt = util.left(error2);
              }
              if (bracketCount === 0) {
                status2 = RETURN;
                step = null;
                fail2 = null;
              }
          }
          return canceler;
        };
      }
      function join2(cb) {
        return function() {
          var canceler = onComplete({
            rethrow: false,
            handler: cb
          })();
          if (status2 === SUSPENDED) {
            run3(runTick);
          }
          return canceler;
        };
      }
      return {
        kill,
        join: join2,
        onComplete,
        isSuspended: function() {
          return status2 === SUSPENDED;
        },
        run: function() {
          if (status2 === SUSPENDED) {
            if (!Scheduler.isDraining()) {
              Scheduler.enqueue(function() {
                run3(runTick);
              });
            } else {
              run3(runTick);
            }
          }
        }
      };
    }
    function runPar(util, supervisor, par, cb) {
      var fiberId = 0;
      var fibers = {};
      var killId = 0;
      var kills = {};
      var early = new Error("[ParAff] Early exit");
      var interrupt = null;
      var root = EMPTY;
      function kill(error2, par2, cb2) {
        var step = par2;
        var head = null;
        var tail = null;
        var count = 0;
        var kills2 = {};
        var tmp, kid;
        loop:
          while (true) {
            tmp = null;
            switch (step.tag) {
              case FORKED:
                if (step._3 === EMPTY) {
                  tmp = fibers[step._1];
                  kills2[count++] = tmp.kill(error2, function(result) {
                    return function() {
                      count--;
                      if (count === 0) {
                        cb2(result)();
                      }
                    };
                  });
                }
                if (head === null) {
                  break loop;
                }
                step = head._2;
                if (tail === null) {
                  head = null;
                } else {
                  head = tail._1;
                  tail = tail._2;
                }
                break;
              case MAP:
                step = step._2;
                break;
              case APPLY:
              case ALT:
                if (head) {
                  tail = new Aff2(CONS, head, tail);
                }
                head = step;
                step = step._1;
                break;
            }
          }
        if (count === 0) {
          cb2(util.right(void 0))();
        } else {
          kid = 0;
          tmp = count;
          for (; kid < tmp; kid++) {
            kills2[kid] = kills2[kid]();
          }
        }
        return kills2;
      }
      function join2(result, head, tail) {
        var fail2, step, lhs, rhs, tmp, kid;
        if (util.isLeft(result)) {
          fail2 = result;
          step = null;
        } else {
          step = result;
          fail2 = null;
        }
        loop:
          while (true) {
            lhs = null;
            rhs = null;
            tmp = null;
            kid = null;
            if (interrupt !== null) {
              return;
            }
            if (head === null) {
              cb(fail2 || step)();
              return;
            }
            if (head._3 !== EMPTY) {
              return;
            }
            switch (head.tag) {
              case MAP:
                if (fail2 === null) {
                  head._3 = util.right(head._1(util.fromRight(step)));
                  step = head._3;
                } else {
                  head._3 = fail2;
                }
                break;
              case APPLY:
                lhs = head._1._3;
                rhs = head._2._3;
                if (fail2) {
                  head._3 = fail2;
                  tmp = true;
                  kid = killId++;
                  kills[kid] = kill(early, fail2 === lhs ? head._2 : head._1, function() {
                    return function() {
                      delete kills[kid];
                      if (tmp) {
                        tmp = false;
                      } else if (tail === null) {
                        join2(fail2, null, null);
                      } else {
                        join2(fail2, tail._1, tail._2);
                      }
                    };
                  });
                  if (tmp) {
                    tmp = false;
                    return;
                  }
                } else if (lhs === EMPTY || rhs === EMPTY) {
                  return;
                } else {
                  step = util.right(util.fromRight(lhs)(util.fromRight(rhs)));
                  head._3 = step;
                }
                break;
              case ALT:
                lhs = head._1._3;
                rhs = head._2._3;
                if (lhs === EMPTY && util.isLeft(rhs) || rhs === EMPTY && util.isLeft(lhs)) {
                  return;
                }
                if (lhs !== EMPTY && util.isLeft(lhs) && rhs !== EMPTY && util.isLeft(rhs)) {
                  fail2 = step === lhs ? rhs : lhs;
                  step = null;
                  head._3 = fail2;
                } else {
                  head._3 = step;
                  tmp = true;
                  kid = killId++;
                  kills[kid] = kill(early, step === lhs ? head._2 : head._1, function() {
                    return function() {
                      delete kills[kid];
                      if (tmp) {
                        tmp = false;
                      } else if (tail === null) {
                        join2(step, null, null);
                      } else {
                        join2(step, tail._1, tail._2);
                      }
                    };
                  });
                  if (tmp) {
                    tmp = false;
                    return;
                  }
                }
                break;
            }
            if (tail === null) {
              head = null;
            } else {
              head = tail._1;
              tail = tail._2;
            }
          }
      }
      function resolve(fiber) {
        return function(result) {
          return function() {
            delete fibers[fiber._1];
            fiber._3 = result;
            join2(result, fiber._2._1, fiber._2._2);
          };
        };
      }
      function run3() {
        var status2 = CONTINUE;
        var step = par;
        var head = null;
        var tail = null;
        var tmp, fid;
        loop:
          while (true) {
            tmp = null;
            fid = null;
            switch (status2) {
              case CONTINUE:
                switch (step.tag) {
                  case MAP:
                    if (head) {
                      tail = new Aff2(CONS, head, tail);
                    }
                    head = new Aff2(MAP, step._1, EMPTY, EMPTY);
                    step = step._2;
                    break;
                  case APPLY:
                    if (head) {
                      tail = new Aff2(CONS, head, tail);
                    }
                    head = new Aff2(APPLY, EMPTY, step._2, EMPTY);
                    step = step._1;
                    break;
                  case ALT:
                    if (head) {
                      tail = new Aff2(CONS, head, tail);
                    }
                    head = new Aff2(ALT, EMPTY, step._2, EMPTY);
                    step = step._1;
                    break;
                  default:
                    fid = fiberId++;
                    status2 = RETURN;
                    tmp = step;
                    step = new Aff2(FORKED, fid, new Aff2(CONS, head, tail), EMPTY);
                    tmp = Fiber(util, supervisor, tmp);
                    tmp.onComplete({
                      rethrow: false,
                      handler: resolve(step)
                    })();
                    fibers[fid] = tmp;
                    if (supervisor) {
                      supervisor.register(tmp);
                    }
                }
                break;
              case RETURN:
                if (head === null) {
                  break loop;
                }
                if (head._1 === EMPTY) {
                  head._1 = step;
                  status2 = CONTINUE;
                  step = head._2;
                  head._2 = EMPTY;
                } else {
                  head._2 = step;
                  step = head;
                  if (tail === null) {
                    head = null;
                  } else {
                    head = tail._1;
                    tail = tail._2;
                  }
                }
            }
          }
        root = step;
        for (fid = 0; fid < fiberId; fid++) {
          fibers[fid].run();
        }
      }
      function cancel(error2, cb2) {
        interrupt = util.left(error2);
        var innerKills;
        for (var kid in kills) {
          if (kills.hasOwnProperty(kid)) {
            innerKills = kills[kid];
            for (kid in innerKills) {
              if (innerKills.hasOwnProperty(kid)) {
                innerKills[kid]();
              }
            }
          }
        }
        kills = null;
        var newKills = kill(error2, root, cb2);
        return function(killError) {
          return new Aff2(ASYNC, function(killCb) {
            return function() {
              for (var kid2 in newKills) {
                if (newKills.hasOwnProperty(kid2)) {
                  newKills[kid2]();
                }
              }
              return nonCanceler2;
            };
          });
        };
      }
      run3();
      return function(killError) {
        return new Aff2(ASYNC, function(killCb) {
          return function() {
            return cancel(killError, killCb);
          };
        });
      };
    }
    function sequential2(util, supervisor, par) {
      return new Aff2(ASYNC, function(cb) {
        return function() {
          return runPar(util, supervisor, par, cb);
        };
      });
    }
    Aff2.EMPTY = EMPTY;
    Aff2.Pure = AffCtr(PURE);
    Aff2.Throw = AffCtr(THROW);
    Aff2.Catch = AffCtr(CATCH);
    Aff2.Sync = AffCtr(SYNC);
    Aff2.Async = AffCtr(ASYNC);
    Aff2.Bind = AffCtr(BIND);
    Aff2.Bracket = AffCtr(BRACKET);
    Aff2.Fork = AffCtr(FORK);
    Aff2.Seq = AffCtr(SEQ);
    Aff2.ParMap = AffCtr(MAP);
    Aff2.ParApply = AffCtr(APPLY);
    Aff2.ParAlt = AffCtr(ALT);
    Aff2.Fiber = Fiber;
    Aff2.Supervisor = Supervisor;
    Aff2.Scheduler = Scheduler;
    Aff2.nonCanceler = nonCanceler2;
    return Aff2;
  }();
  var _pure = Aff.Pure;
  var _throwError = Aff.Throw;
  function _catchError(aff) {
    return function(k) {
      return Aff.Catch(aff, k);
    };
  }
  function _map(f) {
    return function(aff) {
      if (aff.tag === Aff.Pure.tag) {
        return Aff.Pure(f(aff._1));
      } else {
        return Aff.Bind(aff, function(value) {
          return Aff.Pure(f(value));
        });
      }
    };
  }
  function _bind(aff) {
    return function(k) {
      return Aff.Bind(aff, k);
    };
  }
  var _liftEffect = Aff.Sync;
  function _parAffMap(f) {
    return function(aff) {
      return Aff.ParMap(f, aff);
    };
  }
  function _parAffApply(aff1) {
    return function(aff2) {
      return Aff.ParApply(aff1, aff2);
    };
  }
  var makeAff = Aff.Async;
  function _makeFiber(util, aff) {
    return function() {
      return Aff.Fiber(util, null, aff);
    };
  }
  var _delay = function() {
    function setDelay(n, k) {
      if (n === 0 && typeof setImmediate !== "undefined") {
        return setImmediate(k);
      } else {
        return setTimeout(k, n);
      }
    }
    function clearDelay(n, t) {
      if (n === 0 && typeof clearImmediate !== "undefined") {
        return clearImmediate(t);
      } else {
        return clearTimeout(t);
      }
    }
    return function(right, ms) {
      return Aff.Async(function(cb) {
        return function() {
          var timer = setDelay(ms, cb(right()));
          return function() {
            return Aff.Sync(function() {
              return right(clearDelay(ms, timer));
            });
          };
        };
      });
    };
  }();
  var _sequential = Aff.Seq;

  // output/Effect.Exception/foreign.js
  function error(msg) {
    return new Error(msg);
  }

  // output/Control.Monad.Error.Class/index.js
  var throwError = function(dict) {
    return dict.throwError;
  };
  var catchError = function(dict) {
    return dict.catchError;
  };
  var $$try = function(dictMonadError) {
    var catchError1 = catchError(dictMonadError);
    var Monad0 = dictMonadError.MonadThrow0().Monad0();
    var map6 = map(Monad0.Bind1().Apply0().Functor0());
    var pure5 = pure(Monad0.Applicative0());
    return function(a2) {
      return catchError1(map6(Right.create)(a2))(function($52) {
        return pure5(Left.create($52));
      });
    };
  };

  // output/Effect.Class/index.js
  var liftEffect = function(dict) {
    return dict.liftEffect;
  };

  // output/Control.Monad.Except.Trans/index.js
  var map2 = /* @__PURE__ */ map(functorEither);
  var ExceptT = function(x) {
    return x;
  };
  var runExceptT = function(v) {
    return v;
  };
  var mapExceptT = function(f) {
    return function(v) {
      return f(v);
    };
  };
  var functorExceptT = function(dictFunctor) {
    var map1 = map(dictFunctor);
    return {
      map: function(f) {
        return mapExceptT(map1(map2(f)));
      }
    };
  };
  var monadExceptT = function(dictMonad) {
    return {
      Applicative0: function() {
        return applicativeExceptT(dictMonad);
      },
      Bind1: function() {
        return bindExceptT(dictMonad);
      }
    };
  };
  var bindExceptT = function(dictMonad) {
    var bind5 = bind(dictMonad.Bind1());
    var pure5 = pure(dictMonad.Applicative0());
    return {
      bind: function(v) {
        return function(k) {
          return bind5(v)(either(function($187) {
            return pure5(Left.create($187));
          })(function(a2) {
            var v1 = k(a2);
            return v1;
          }));
        };
      },
      Apply0: function() {
        return applyExceptT(dictMonad);
      }
    };
  };
  var applyExceptT = function(dictMonad) {
    var functorExceptT1 = functorExceptT(dictMonad.Bind1().Apply0().Functor0());
    return {
      apply: ap(monadExceptT(dictMonad)),
      Functor0: function() {
        return functorExceptT1;
      }
    };
  };
  var applicativeExceptT = function(dictMonad) {
    return {
      pure: function() {
        var $188 = pure(dictMonad.Applicative0());
        return function($189) {
          return ExceptT($188(Right.create($189)));
        };
      }(),
      Apply0: function() {
        return applyExceptT(dictMonad);
      }
    };
  };
  var monadThrowExceptT = function(dictMonad) {
    var monadExceptT1 = monadExceptT(dictMonad);
    return {
      throwError: function() {
        var $198 = pure(dictMonad.Applicative0());
        return function($199) {
          return ExceptT($198(Left.create($199)));
        };
      }(),
      Monad0: function() {
        return monadExceptT1;
      }
    };
  };
  var altExceptT = function(dictSemigroup) {
    var append2 = append(dictSemigroup);
    return function(dictMonad) {
      var Bind1 = dictMonad.Bind1();
      var bind5 = bind(Bind1);
      var pure5 = pure(dictMonad.Applicative0());
      var functorExceptT1 = functorExceptT(Bind1.Apply0().Functor0());
      return {
        alt: function(v) {
          return function(v1) {
            return bind5(v)(function(rm) {
              if (rm instanceof Right) {
                return pure5(new Right(rm.value0));
              }
              ;
              if (rm instanceof Left) {
                return bind5(v1)(function(rn) {
                  if (rn instanceof Right) {
                    return pure5(new Right(rn.value0));
                  }
                  ;
                  if (rn instanceof Left) {
                    return pure5(new Left(append2(rm.value0)(rn.value0)));
                  }
                  ;
                  throw new Error("Failed pattern match at Control.Monad.Except.Trans (line 86, column 9 - line 88, column 49): " + [rn.constructor.name]);
                });
              }
              ;
              throw new Error("Failed pattern match at Control.Monad.Except.Trans (line 82, column 5 - line 88, column 49): " + [rm.constructor.name]);
            });
          };
        },
        Functor0: function() {
          return functorExceptT1;
        }
      };
    };
  };

  // output/Control.Parallel.Class/index.js
  var sequential = function(dict) {
    return dict.sequential;
  };
  var parallel = function(dict) {
    return dict.parallel;
  };

  // output/Control.Parallel/index.js
  var identity4 = /* @__PURE__ */ identity(categoryFn);
  var parTraverse_ = function(dictParallel) {
    var sequential2 = sequential(dictParallel);
    var traverse_2 = traverse_(dictParallel.Applicative1());
    var parallel2 = parallel(dictParallel);
    return function(dictFoldable) {
      var traverse_1 = traverse_2(dictFoldable);
      return function(f) {
        var $48 = traverse_1(function($50) {
          return parallel2(f($50));
        });
        return function($49) {
          return sequential2($48($49));
        };
      };
    };
  };
  var parSequence_ = function(dictParallel) {
    var parTraverse_1 = parTraverse_(dictParallel);
    return function(dictFoldable) {
      return parTraverse_1(dictFoldable)(identity4);
    };
  };

  // output/Partial.Unsafe/foreign.js
  var _unsafePartial = function(f) {
    return f();
  };

  // output/Partial/foreign.js
  var _crashWith = function(msg) {
    throw new Error(msg);
  };

  // output/Partial/index.js
  var crashWith = function() {
    return _crashWith;
  };

  // output/Partial.Unsafe/index.js
  var crashWith2 = /* @__PURE__ */ crashWith();
  var unsafePartial = _unsafePartial;
  var unsafeCrashWith = function(msg) {
    return unsafePartial(function() {
      return crashWith2(msg);
    });
  };

  // output/Effect.Aff/index.js
  var $runtime_lazy2 = function(name2, moduleName, init3) {
    var state2 = 0;
    var val;
    return function(lineNumber) {
      if (state2 === 2)
        return val;
      if (state2 === 1)
        throw new ReferenceError(name2 + " was needed before it finished initializing (module " + moduleName + ", line " + lineNumber + ")", moduleName, lineNumber);
      state2 = 1;
      val = init3();
      state2 = 2;
      return val;
    };
  };
  var $$void2 = /* @__PURE__ */ $$void(functorEffect);
  var functorParAff = {
    map: _parAffMap
  };
  var functorAff = {
    map: _map
  };
  var ffiUtil = /* @__PURE__ */ function() {
    var unsafeFromRight = function(v) {
      if (v instanceof Right) {
        return v.value0;
      }
      ;
      if (v instanceof Left) {
        return unsafeCrashWith("unsafeFromRight: Left");
      }
      ;
      throw new Error("Failed pattern match at Effect.Aff (line 412, column 21 - line 414, column 54): " + [v.constructor.name]);
    };
    var unsafeFromLeft = function(v) {
      if (v instanceof Left) {
        return v.value0;
      }
      ;
      if (v instanceof Right) {
        return unsafeCrashWith("unsafeFromLeft: Right");
      }
      ;
      throw new Error("Failed pattern match at Effect.Aff (line 407, column 20 - line 409, column 55): " + [v.constructor.name]);
    };
    var isLeft2 = function(v) {
      if (v instanceof Left) {
        return true;
      }
      ;
      if (v instanceof Right) {
        return false;
      }
      ;
      throw new Error("Failed pattern match at Effect.Aff (line 402, column 12 - line 404, column 21): " + [v.constructor.name]);
    };
    return {
      isLeft: isLeft2,
      fromLeft: unsafeFromLeft,
      fromRight: unsafeFromRight,
      left: Left.create,
      right: Right.create
    };
  }();
  var makeFiber = function(aff) {
    return _makeFiber(ffiUtil, aff);
  };
  var launchAff = function(aff) {
    return function __do2() {
      var fiber = makeFiber(aff)();
      fiber.run();
      return fiber;
    };
  };
  var applyParAff = {
    apply: _parAffApply,
    Functor0: function() {
      return functorParAff;
    }
  };
  var monadAff = {
    Applicative0: function() {
      return applicativeAff;
    },
    Bind1: function() {
      return bindAff;
    }
  };
  var bindAff = {
    bind: _bind,
    Apply0: function() {
      return $lazy_applyAff(0);
    }
  };
  var applicativeAff = {
    pure: _pure,
    Apply0: function() {
      return $lazy_applyAff(0);
    }
  };
  var $lazy_applyAff = /* @__PURE__ */ $runtime_lazy2("applyAff", "Effect.Aff", function() {
    return {
      apply: ap(monadAff),
      Functor0: function() {
        return functorAff;
      }
    };
  });
  var applyAff = /* @__PURE__ */ $lazy_applyAff(73);
  var pure2 = /* @__PURE__ */ pure(applicativeAff);
  var lift21 = /* @__PURE__ */ lift2(applyAff);
  var bindFlipped2 = /* @__PURE__ */ bindFlipped(bindAff);
  var semigroupAff = function(dictSemigroup) {
    return {
      append: lift21(append(dictSemigroup))
    };
  };
  var monadEffectAff = {
    liftEffect: _liftEffect,
    Monad0: function() {
      return monadAff;
    }
  };
  var liftEffect2 = /* @__PURE__ */ liftEffect(monadEffectAff);
  var monadThrowAff = {
    throwError: _throwError,
    Monad0: function() {
      return monadAff;
    }
  };
  var monadErrorAff = {
    catchError: _catchError,
    MonadThrow0: function() {
      return monadThrowAff;
    }
  };
  var $$try2 = /* @__PURE__ */ $$try(monadErrorAff);
  var runAff = function(k) {
    return function(aff) {
      return launchAff(bindFlipped2(function($80) {
        return liftEffect2(k($80));
      })($$try2(aff)));
    };
  };
  var runAff_ = function(k) {
    return function(aff) {
      return $$void2(runAff(k)(aff));
    };
  };
  var parallelAff = {
    parallel: unsafeCoerce2,
    sequential: _sequential,
    Monad0: function() {
      return monadAff;
    },
    Applicative1: function() {
      return $lazy_applicativeParAff(0);
    }
  };
  var $lazy_applicativeParAff = /* @__PURE__ */ $runtime_lazy2("applicativeParAff", "Effect.Aff", function() {
    return {
      pure: function() {
        var $82 = parallel(parallelAff);
        return function($83) {
          return $82(pure2($83));
        };
      }(),
      Apply0: function() {
        return applyParAff;
      }
    };
  });
  var parSequence_2 = /* @__PURE__ */ parSequence_(parallelAff)(foldableArray);
  var semigroupCanceler = {
    append: function(v) {
      return function(v1) {
        return function(err) {
          return parSequence_2([v(err), v1(err)]);
        };
      };
    }
  };
  var monoidAff = function(dictMonoid) {
    var semigroupAff1 = semigroupAff(dictMonoid.Semigroup0());
    return {
      mempty: pure2(mempty(dictMonoid)),
      Semigroup0: function() {
        return semigroupAff1;
      }
    };
  };
  var nonCanceler = /* @__PURE__ */ $$const(/* @__PURE__ */ pure2(unit));
  var monoidCanceler = {
    mempty: nonCanceler,
    Semigroup0: function() {
      return semigroupCanceler;
    }
  };

  // output/Control.Promise/foreign.js
  function thenImpl(promise2) {
    return function(errCB) {
      return function(succCB) {
        return function() {
          promise2.then(succCB, errCB);
        };
      };
    };
  }

  // output/Control.Monad.Except/index.js
  var unwrap2 = /* @__PURE__ */ unwrap();
  var runExcept = function($3) {
    return unwrap2(runExceptT($3));
  };

  // output/Data.NonEmpty/index.js
  var NonEmpty = /* @__PURE__ */ function() {
    function NonEmpty2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    NonEmpty2.create = function(value0) {
      return function(value1) {
        return new NonEmpty2(value0, value1);
      };
    };
    return NonEmpty2;
  }();
  var singleton2 = function(dictPlus) {
    var empty4 = empty(dictPlus);
    return function(a2) {
      return new NonEmpty(a2, empty4);
    };
  };

  // output/Data.List.Types/index.js
  var Nil = /* @__PURE__ */ function() {
    function Nil2() {
    }
    ;
    Nil2.value = new Nil2();
    return Nil2;
  }();
  var Cons = /* @__PURE__ */ function() {
    function Cons2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    Cons2.create = function(value0) {
      return function(value1) {
        return new Cons2(value0, value1);
      };
    };
    return Cons2;
  }();
  var NonEmptyList = function(x) {
    return x;
  };
  var toList = function(v) {
    return new Cons(v.value0, v.value1);
  };
  var listMap = function(f) {
    var chunkedRevMap = function($copy_chunksAcc) {
      return function($copy_v) {
        var $tco_var_chunksAcc = $copy_chunksAcc;
        var $tco_done = false;
        var $tco_result;
        function $tco_loop(chunksAcc, v) {
          if (v instanceof Cons && (v.value1 instanceof Cons && v.value1.value1 instanceof Cons)) {
            $tco_var_chunksAcc = new Cons(v, chunksAcc);
            $copy_v = v.value1.value1.value1;
            return;
          }
          ;
          var unrolledMap = function(v1) {
            if (v1 instanceof Cons && (v1.value1 instanceof Cons && v1.value1.value1 instanceof Nil)) {
              return new Cons(f(v1.value0), new Cons(f(v1.value1.value0), Nil.value));
            }
            ;
            if (v1 instanceof Cons && v1.value1 instanceof Nil) {
              return new Cons(f(v1.value0), Nil.value);
            }
            ;
            return Nil.value;
          };
          var reverseUnrolledMap = function($copy_v1) {
            return function($copy_acc) {
              var $tco_var_v1 = $copy_v1;
              var $tco_done1 = false;
              var $tco_result2;
              function $tco_loop2(v1, acc) {
                if (v1 instanceof Cons && (v1.value0 instanceof Cons && (v1.value0.value1 instanceof Cons && v1.value0.value1.value1 instanceof Cons))) {
                  $tco_var_v1 = v1.value1;
                  $copy_acc = new Cons(f(v1.value0.value0), new Cons(f(v1.value0.value1.value0), new Cons(f(v1.value0.value1.value1.value0), acc)));
                  return;
                }
                ;
                $tco_done1 = true;
                return acc;
              }
              ;
              while (!$tco_done1) {
                $tco_result2 = $tco_loop2($tco_var_v1, $copy_acc);
              }
              ;
              return $tco_result2;
            };
          };
          $tco_done = true;
          return reverseUnrolledMap(chunksAcc)(unrolledMap(v));
        }
        ;
        while (!$tco_done) {
          $tco_result = $tco_loop($tco_var_chunksAcc, $copy_v);
        }
        ;
        return $tco_result;
      };
    };
    return chunkedRevMap(Nil.value);
  };
  var functorList = {
    map: listMap
  };
  var foldableList = {
    foldr: function(f) {
      return function(b2) {
        var rev = function() {
          var go = function($copy_acc) {
            return function($copy_v) {
              var $tco_var_acc = $copy_acc;
              var $tco_done = false;
              var $tco_result;
              function $tco_loop(acc, v) {
                if (v instanceof Nil) {
                  $tco_done = true;
                  return acc;
                }
                ;
                if (v instanceof Cons) {
                  $tco_var_acc = new Cons(v.value0, acc);
                  $copy_v = v.value1;
                  return;
                }
                ;
                throw new Error("Failed pattern match at Data.List.Types (line 107, column 7 - line 107, column 23): " + [acc.constructor.name, v.constructor.name]);
              }
              ;
              while (!$tco_done) {
                $tco_result = $tco_loop($tco_var_acc, $copy_v);
              }
              ;
              return $tco_result;
            };
          };
          return go(Nil.value);
        }();
        var $281 = foldl(foldableList)(flip(f))(b2);
        return function($282) {
          return $281(rev($282));
        };
      };
    },
    foldl: function(f) {
      var go = function($copy_b) {
        return function($copy_v) {
          var $tco_var_b = $copy_b;
          var $tco_done1 = false;
          var $tco_result;
          function $tco_loop(b2, v) {
            if (v instanceof Nil) {
              $tco_done1 = true;
              return b2;
            }
            ;
            if (v instanceof Cons) {
              $tco_var_b = f(b2)(v.value0);
              $copy_v = v.value1;
              return;
            }
            ;
            throw new Error("Failed pattern match at Data.List.Types (line 111, column 12 - line 113, column 30): " + [v.constructor.name]);
          }
          ;
          while (!$tco_done1) {
            $tco_result = $tco_loop($tco_var_b, $copy_v);
          }
          ;
          return $tco_result;
        };
      };
      return go;
    },
    foldMap: function(dictMonoid) {
      var append2 = append(dictMonoid.Semigroup0());
      var mempty5 = mempty(dictMonoid);
      return function(f) {
        return foldl(foldableList)(function(acc) {
          var $283 = append2(acc);
          return function($284) {
            return $283(f($284));
          };
        })(mempty5);
      };
    }
  };
  var foldr2 = /* @__PURE__ */ foldr(foldableList);
  var semigroupList = {
    append: function(xs) {
      return function(ys) {
        return foldr2(Cons.create)(ys)(xs);
      };
    }
  };
  var append1 = /* @__PURE__ */ append(semigroupList);
  var semigroupNonEmptyList = {
    append: function(v) {
      return function(as$prime) {
        return new NonEmpty(v.value0, append1(v.value1)(toList(as$prime)));
      };
    }
  };
  var altList = {
    alt: append1,
    Functor0: function() {
      return functorList;
    }
  };
  var plusList = /* @__PURE__ */ function() {
    return {
      empty: Nil.value,
      Alt0: function() {
        return altList;
      }
    };
  }();

  // output/Foreign/foreign.js
  function tagOf(value) {
    return Object.prototype.toString.call(value).slice(8, -1);
  }
  var isArray = Array.isArray || function(value) {
    return Object.prototype.toString.call(value) === "[object Array]";
  };

  // output/Data.List.NonEmpty/index.js
  var singleton3 = /* @__PURE__ */ function() {
    var $199 = singleton2(plusList);
    return function($200) {
      return NonEmptyList($199($200));
    };
  }();

  // output/Foreign/index.js
  var TypeMismatch = /* @__PURE__ */ function() {
    function TypeMismatch2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    TypeMismatch2.create = function(value0) {
      return function(value1) {
        return new TypeMismatch2(value0, value1);
      };
    };
    return TypeMismatch2;
  }();
  var unsafeFromForeign = unsafeCoerce2;
  var fail = function(dictMonad) {
    var $153 = throwError(monadThrowExceptT(dictMonad));
    return function($154) {
      return $153(singleton3($154));
    };
  };
  var unsafeReadTagged = function(dictMonad) {
    var pure12 = pure(applicativeExceptT(dictMonad));
    var fail1 = fail(dictMonad);
    return function(tag) {
      return function(value) {
        if (tagOf(value) === tag) {
          return pure12(unsafeFromForeign(value));
        }
        ;
        if (otherwise) {
          return fail1(new TypeMismatch(tag, tagOf(value)));
        }
        ;
        throw new Error("Failed pattern match at Foreign (line 123, column 1 - line 123, column 104): " + [tag.constructor.name, value.constructor.name]);
      };
    };
  };
  var readString = function(dictMonad) {
    return unsafeReadTagged(dictMonad)("String");
  };

  // output/Control.Promise/index.js
  var voidRight2 = /* @__PURE__ */ voidRight(functorEffect);
  var mempty2 = /* @__PURE__ */ mempty(monoidCanceler);
  var identity5 = /* @__PURE__ */ identity(categoryFn);
  var alt2 = /* @__PURE__ */ alt(/* @__PURE__ */ altExceptT(semigroupNonEmptyList)(monadIdentity));
  var unsafeReadTagged2 = /* @__PURE__ */ unsafeReadTagged(monadIdentity);
  var map3 = /* @__PURE__ */ map(/* @__PURE__ */ functorExceptT(functorIdentity));
  var readString2 = /* @__PURE__ */ readString(monadIdentity);
  var bind2 = /* @__PURE__ */ bind(bindAff);
  var liftEffect3 = /* @__PURE__ */ liftEffect(monadEffectAff);
  var toAff$prime = function(customCoerce) {
    return function(p2) {
      return makeAff(function(cb) {
        return voidRight2(mempty2)(thenImpl(p2)(function($14) {
          return cb(Left.create(customCoerce($14)))();
        })(function($15) {
          return cb(Right.create($15))();
        }));
      });
    };
  };
  var coerce3 = function(fn) {
    return either(function(v) {
      return error("Promise failed, couldn't extract JS Error or String");
    })(identity5)(runExcept(alt2(unsafeReadTagged2("Error")(fn))(map3(error)(readString2(fn)))));
  };
  var toAff = /* @__PURE__ */ toAff$prime(coerce3);
  var toAffE = function(f) {
    return bind2(liftEffect3(f))(toAff);
  };

  // output/Fetch.Core/foreign.js
  function _fetch(a2, b2) {
    return fetch(a2, b2);
  }

  // output/Fetch.Core/index.js
  var fetch2 = function(req) {
    return function() {
      return _fetch(req, {});
    };
  };

  // output/Data.Function.Uncurried/foreign.js
  var runFn3 = function(fn) {
    return function(a2) {
      return function(b2) {
        return function(c) {
          return fn(a2, b2, c);
        };
      };
    };
  };

  // output/Data.Function.Uncurried/index.js
  var runFn1 = function(f) {
    return f;
  };

  // output/Fetch.Core.Request/foreign.js
  function _unsafeNew(url2, options) {
    try {
      return new Request(url2, options);
    } catch (e) {
      console.error(e);
      throw e;
    }
  }

  // output/Fetch.Internal.Request/index.js
  var toCoreRequestOptionsHelpe = {
    convertHelper: function(v) {
      return function(v1) {
        return {};
      };
    }
  };
  var $$new2 = function() {
    return function(url2) {
      return function(options) {
        return function() {
          return _unsafeNew(url2, options);
        };
      };
    };
  };
  var convertHelper = function(dict) {
    return dict.convertHelper;
  };
  var toCoreRequestOptionsRowRo = function() {
    return function() {
      return function(dictToCoreRequestOptionsHelper) {
        return {
          convert: convertHelper(dictToCoreRequestOptionsHelper)($$Proxy.value)
        };
      };
    };
  };
  var convert = function(dict) {
    return dict.convert;
  };

  // output/Fetch.Core.Response/foreign.js
  function headers(resp) {
    return resp.headers;
  }
  function ok(resp) {
    return resp.ok;
  }
  function redirected(resp) {
    return resp.redirected;
  }
  function status(resp) {
    return resp.status;
  }
  function statusText(resp) {
    return resp.statusText;
  }
  function url(resp) {
    return resp.url;
  }
  function body(resp) {
    return function() {
      return resp.body;
    };
  }
  function arrayBuffer(resp) {
    return function() {
      return resp.arrayBuffer();
    };
  }
  function blob(resp) {
    return function() {
      return resp.blob();
    };
  }
  function text(resp) {
    return function() {
      return resp.text();
    };
  }
  function json(resp) {
    return function() {
      return resp.json();
    };
  }

  // output/Fetch.Internal.Response/index.js
  var mapFlipped2 = /* @__PURE__ */ mapFlipped(functorEffect);
  var promiseToPromise = unsafeCoerce2;
  var text2 = function(response) {
    return toAffE(mapFlipped2(text(response))(promiseToPromise));
  };
  var json2 = function(response) {
    return toAffE(mapFlipped2(json(response))(promiseToPromise));
  };
  var blob2 = function(response) {
    return toAffE(mapFlipped2(blob(response))(promiseToPromise));
  };
  var arrayBuffer2 = function(response) {
    return toAffE(mapFlipped2(arrayBuffer(response))(promiseToPromise));
  };
  var convert2 = function(response) {
    return {
      headers: headers(response),
      ok: ok(response),
      redirected: redirected(response),
      status: status(response),
      statusText: statusText(response),
      url: url(response),
      text: text2(response),
      json: json2(response),
      body: body(response),
      arrayBuffer: arrayBuffer2(response),
      blob: blob2(response)
    };
  };

  // output/Fetch/index.js
  var bind3 = /* @__PURE__ */ bind(bindAff);
  var liftEffect4 = /* @__PURE__ */ liftEffect(monadEffectAff);
  var $$new3 = /* @__PURE__ */ $$new2();
  var map4 = /* @__PURE__ */ map(functorEffect);
  var pure3 = /* @__PURE__ */ pure(applicativeAff);
  var fetch3 = function() {
    return function() {
      return function(dictToCoreRequestOptions) {
        var convert3 = convert(dictToCoreRequestOptions);
        return function(url2) {
          return function(r) {
            return bind3(liftEffect4($$new3(url2)(convert3(r))))(function(request) {
              return bind3(toAffE(map4(promiseToPromise)(fetch2(request))))(function(cResponse) {
                return pure3(convert2(cResponse));
              });
            });
          };
        };
      };
    };
  };

  // output/Oak.Document/foreign.js
  function getElementByIdImpl(id) {
    return function() {
      var container = document.getElementById(id);
      if (container == null) {
        throw new Error("Unable to find element with ID: " + id);
      }
      return container;
    };
  }
  function appendChildNodeImpl(container) {
    return function(rootNode) {
      return function() {
        console.log("container", container);
        console.log("rootNode", rootNode);
        container.appendChild(rootNode);
      };
    };
  }

  // output/Oak.Document/index.js
  var getElementById = /* @__PURE__ */ runFn1(getElementByIdImpl);
  var appendChildNode = function(element) {
    return function(rootNode) {
      return appendChildNodeImpl(element)(rootNode);
    };
  };

  // output/Oak.Html.Attribute/index.js
  var BooleanAttribute = /* @__PURE__ */ function() {
    function BooleanAttribute2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    BooleanAttribute2.create = function(value0) {
      return function(value1) {
        return new BooleanAttribute2(value0, value1);
      };
    };
    return BooleanAttribute2;
  }();
  var DataAttribute = /* @__PURE__ */ function() {
    function DataAttribute2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    DataAttribute2.create = function(value0) {
      return function(value1) {
        return new DataAttribute2(value0, value1);
      };
    };
    return DataAttribute2;
  }();
  var EventHandler = /* @__PURE__ */ function() {
    function EventHandler2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    EventHandler2.create = function(value0) {
      return function(value1) {
        return new EventHandler2(value0, value1);
      };
    };
    return EventHandler2;
  }();
  var KeyPressEventHandler = /* @__PURE__ */ function() {
    function KeyPressEventHandler2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    KeyPressEventHandler2.create = function(value0) {
      return function(value1) {
        return new KeyPressEventHandler2(value0, value1);
      };
    };
    return KeyPressEventHandler2;
  }();
  var SimpleAttribute = /* @__PURE__ */ function() {
    function SimpleAttribute2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    SimpleAttribute2.create = function(value0) {
      return function(value1) {
        return new SimpleAttribute2(value0, value1);
      };
    };
    return SimpleAttribute2;
  }();
  var StringEventHandler = /* @__PURE__ */ function() {
    function StringEventHandler2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    StringEventHandler2.create = function(value0) {
      return function(value1) {
        return new StringEventHandler2(value0, value1);
      };
    };
    return StringEventHandler2;
  }();
  var Style = /* @__PURE__ */ function() {
    function Style2(value0) {
      this.value0 = value0;
    }
    ;
    Style2.create = function(value0) {
      return new Style2(value0);
    };
    return Style2;
  }();

  // output/Oak.Html/index.js
  var Text = /* @__PURE__ */ function() {
    function Text2(value0) {
      this.value0 = value0;
    }
    ;
    Text2.create = function(value0) {
      return new Text2(value0);
    };
    return Text2;
  }();
  var Tag = /* @__PURE__ */ function() {
    function Tag2(value0, value1, value2) {
      this.value0 = value0;
      this.value1 = value1;
      this.value2 = value2;
    }
    ;
    Tag2.create = function(value0) {
      return function(value1) {
        return function(value2) {
          return new Tag2(value0, value1, value2);
        };
      };
    };
    return Tag2;
  }();
  var text3 = function(val) {
    return new Text(val);
  };
  var mkTagFn = function(n) {
    return function(attrs) {
      return function(m) {
        return new Tag(n, attrs, m);
      };
    };
  };
  var div2 = /* @__PURE__ */ mkTagFn("div");
  var button = /* @__PURE__ */ mkTagFn("button");

  // output/Oak.Html.Events/index.js
  var onClick = function(msg) {
    return new EventHandler("onclick", msg);
  };

  // output/Oak.VirtualDom.Native/foreign.js
  var h = require_h();
  var diff = require_diff2();
  var patch = require_patch2();
  var createElement = require_create_element2();
  function createRootNodeImpl(tree) {
    console.log("tree", tree);
    const el = createElement(tree);
    console.log("el", el);
    return el;
  }
  function textImpl(str) {
    return function() {
      return str;
    };
  }
  function renderImpl(tagName, attrs, childrenEff) {
    return function() {
      var children = childrenEff();
      return h(tagName, attrs, children);
    };
  }
  function patchImpl(newTree, oldTree, rootNode) {
    return function() {
      var patches = diff(oldTree, newTree);
      return patch(rootNode, patches);
    };
  }
  function concatHandlerFunImpl(name2, msgHandler, rest) {
    var result = Object.assign({}, rest);
    result[name2] = function(event) {
      msgHandler(event)();
    };
    return result;
  }
  function concatEventTargetValueHandlerFunImpl(name2, msgHandler, rest) {
    var result = Object.assign({}, rest);
    result[name2] = function(event) {
      msgHandler(String(event.target.value))();
    };
    return result;
  }
  function concatSimpleAttrImpl(name2, value, rest) {
    var result = Object.assign({}, rest);
    result[name2] = value;
    return result;
  }
  function concatBooleanAttrImpl(name2, b2, rest) {
    if (b2) {
      var result = Object.assign({}, rest);
      result[name2] = name2;
      return result;
    } else {
      return rest;
    }
  }
  function concatDataAttrImpl(name2, val, rest) {
    var result = Object.assign({}, rest);
    var attributes = Object.assign({}, rest.attributes);
    attributes[name2] = val;
    result.attributes = attributes;
    return result;
  }
  function emptyAttrs() {
    return {};
  }

  // output/Oak.VirtualDom.Native/index.js
  var text4 = /* @__PURE__ */ runFn1(textImpl);
  var render = /* @__PURE__ */ runFn3(renderImpl);
  var patch2 = /* @__PURE__ */ runFn3(patchImpl);
  var createRootNode = /* @__PURE__ */ runFn1(createRootNodeImpl);
  var concatSimpleAttr = /* @__PURE__ */ runFn3(concatSimpleAttrImpl);
  var concatHandlerFun = /* @__PURE__ */ runFn3(concatHandlerFunImpl);
  var concatEventTargetValueHandlerFun = /* @__PURE__ */ runFn3(concatEventTargetValueHandlerFunImpl);
  var concatDataAttr = /* @__PURE__ */ runFn3(concatDataAttrImpl);
  var concatBooleanAttr = /* @__PURE__ */ runFn3(concatBooleanAttrImpl);

  // output/Oak.VirtualDom/index.js
  var intercalate3 = /* @__PURE__ */ intercalate(foldableArray)(monoidString);
  var map5 = /* @__PURE__ */ map(functorArray);
  var foldr3 = /* @__PURE__ */ foldr(foldableArray);
  var sequence2 = /* @__PURE__ */ sequence(traversableArray)(applicativeEffect);
  var stringifyStyle = function(v) {
    return v.value0 + (":" + v.value1);
  };
  var stringifyStyles = function(attrs) {
    return intercalate3(";")(map5(stringifyStyle)(attrs));
  };
  var patch3 = function(oldTree) {
    return function(newTree) {
      return function(root) {
        return patch2(oldTree)(newTree)(root);
      };
    };
  };
  var concatAttr = function(v) {
    return function(v1) {
      return function(attrs) {
        if (v1 instanceof EventHandler) {
          return concatHandlerFun(v1.value0)(function(v2) {
            return v(v1.value1);
          })(attrs);
        }
        ;
        if (v1 instanceof StringEventHandler) {
          return concatEventTargetValueHandlerFun(v1.value0)(function(e) {
            return v(v1.value1(e));
          })(attrs);
        }
        ;
        if (v1 instanceof SimpleAttribute) {
          return concatSimpleAttr(v1.value0)(v1.value1)(attrs);
        }
        ;
        if (v1 instanceof Style) {
          return concatSimpleAttr("style")(stringifyStyles(v1.value0))(attrs);
        }
        ;
        if (v1 instanceof BooleanAttribute) {
          return concatBooleanAttr(v1.value0)(v1.value1)(attrs);
        }
        ;
        if (v1 instanceof DataAttribute) {
          return concatDataAttr(v1.value0)(v1.value1)(attrs);
        }
        ;
        if (v1 instanceof KeyPressEventHandler) {
          return concatHandlerFun(v1.value0)(function(e) {
            return v(v1.value1(e));
          })(attrs);
        }
        ;
        throw new Error("Failed pattern match at Oak.VirtualDom (line 26, column 1 - line 31, column 19): " + [v.constructor.name, v1.constructor.name, attrs.constructor.name]);
      };
    };
  };
  var combineAttrs = function(attrs) {
    return function(handler2) {
      return foldr3(concatAttr(handler2))(emptyAttrs)(attrs);
    };
  };
  var renderTag = function(v) {
    return function(v1) {
      if (v1 instanceof Tag) {
        var rendered = sequence2(map5(renderTag(v))(v1.value2));
        return render(v1.value0)(combineAttrs(v1.value1)(v))(rendered);
      }
      ;
      if (v1 instanceof Text) {
        return text4(v1.value0);
      }
      ;
      throw new Error("Failed pattern match at Oak.VirtualDom (line 17, column 1 - line 17, column 74): " + [v.constructor.name, v1.constructor.name]);
    };
  };
  var render2 = function(h7) {
    return function(xs) {
      return renderTag(h7)(xs);
    };
  };

  // output/Oak/index.js
  var mempty3 = /* @__PURE__ */ mempty(/* @__PURE__ */ monoidEffect(monoidUnit));
  var fromJust2 = /* @__PURE__ */ fromJust();
  var RunningApp = /* @__PURE__ */ function() {
    function RunningApp2(value0) {
      this.value0 = value0;
    }
    ;
    RunningApp2.create = function(value0) {
      return new RunningApp2(value0);
    };
    return RunningApp2;
  }();
  var App2 = /* @__PURE__ */ function() {
    function App3(value0) {
      this.value0 = value0;
    }
    ;
    App3.create = function(value0) {
      return new App3(value0);
    };
    return App3;
  }();
  var handler = function(ref) {
    return function(runningApp) {
      return function(msg) {
        var handleAff = function(v) {
          if (v instanceof Right) {
            return handler(ref)(runningApp)(v.value0);
          }
          ;
          return mempty3;
        };
        return function __do2() {
          var env = read(ref)();
          var oldTree = fromJust2(env.tree);
          var oldRoot = fromJust2(env.root);
          var newModel = runningApp.value0.update(msg)(env.model);
          var newTree = render2(handler(ref)(runningApp))(runningApp.value0.view(newModel))();
          var newRoot = patch3(newTree)(oldTree)(oldRoot)();
          var newRuntime = {
            root: new Just(newRoot),
            tree: new Just(newTree),
            model: newModel
          };
          write(newRuntime)(ref)();
          var aff = runningApp.value0.next(msg)(newModel);
          return runAff_(handleAff)(aff)();
        };
      };
    };
  };
  var runApp_ = function(v) {
    return function(msg) {
      var runningApp = {
        view: v.value0.view,
        next: v.value0.next,
        update: v.value0.update
      };
      return function __do2() {
        var ref = $$new({
          tree: Nothing.value,
          root: Nothing.value,
          model: v.value0.init
        })();
        var tree = render2(handler(ref)(new RunningApp(runningApp)))(runningApp.view(v.value0.init))();
        var rootNode = createRootNode(tree);
        write({
          tree: new Just(tree),
          root: new Just(rootNode),
          model: v.value0.init
        })(ref)();
        (function() {
          if (msg instanceof Just) {
            return handler(ref)(new RunningApp(runningApp))(msg.value0)();
          }
          ;
          if (msg instanceof Nothing) {
            return unit;
          }
          ;
          throw new Error("Failed pattern match at Oak (line 233, column 3 - line 235, column 25): " + [msg.constructor.name]);
        })();
        return rootNode;
      };
    };
  };
  var runApp = function(msg) {
    return function(app2) {
      return runApp_(msg)(app2);
    };
  };
  var createApp = function(opts) {
    return new App2({
      init: opts.init,
      view: opts.view,
      next: opts.next,
      update: opts.update
    });
  };

  // output/Main/index.js
  var bind4 = /* @__PURE__ */ bind(bindArray);
  var discard2 = /* @__PURE__ */ discard(discardUnit)(bindArray);
  var guard2 = /* @__PURE__ */ guard(alternativeArray);
  var pure4 = /* @__PURE__ */ pure(applicativeArray);
  var show2 = /* @__PURE__ */ show(showInt);
  var bind1 = /* @__PURE__ */ bind(bindAff);
  var fetch4 = /* @__PURE__ */ fetch3()()(/* @__PURE__ */ toCoreRequestOptionsRowRo()()(toCoreRequestOptionsHelpe));
  var pure1 = /* @__PURE__ */ pure(applicativeAff);
  var Other = /* @__PURE__ */ function() {
    function Other2(value0) {
      this.value0 = value0;
    }
    ;
    Other2.create = function(value0) {
      return new Other2(value0);
    };
    return Other2;
  }();
  var GoGet = /* @__PURE__ */ function() {
    function GoGet2() {
    }
    ;
    GoGet2.value = new GoGet2();
    return GoGet2;
  }();
  var Nada = /* @__PURE__ */ function() {
    function Nada2() {
    }
    ;
    Nada2.value = new Nada2();
    return Nada2;
  }();
  var view = function(model) {
    return div2([])([text3(model.message), text3("this is the parent app"), div2([])([button([onClick(GoGet.value)])([text3("Other")])]), div2([])(bind4(range(1)(10))(function(x) {
      return discard2(guard2(even(x)))(function() {
        return pure4(div2([])([text3(show2(x))]));
      });
    }))]);
  };
  var update = function(msg) {
    return function(model) {
      if (msg instanceof Other) {
        return {
          message: msg.value0
        };
      }
      ;
      if (msg instanceof GoGet) {
        return model;
      }
      ;
      if (msg instanceof Nada) {
        return model;
      }
      ;
      throw new Error("Failed pattern match at Main (line 82, column 20 - line 85, column 16): " + [msg.constructor.name]);
    };
  };
  var semigroupMsg = {
    append: function(v) {
      return function(x) {
        return x;
      };
    }
  };
  var monoidMsg = /* @__PURE__ */ function() {
    return {
      mempty: Nada.value,
      Semigroup0: function() {
        return semigroupMsg;
      }
    };
  }();
  var mempty4 = /* @__PURE__ */ mempty(/* @__PURE__ */ monoidAff(monoidMsg));
  var next = function(msg) {
    return function(mod2) {
      if (msg instanceof GoGet) {
        return bind1(fetch4("https://httpbin.org/get")({}))(function(v) {
          return bind1(v.text)(function(contents) {
            return pure1(new Other(contents));
          });
        });
      }
      ;
      return mempty4;
    };
  };
  var init2 = {
    message: ""
  };
  var app = /* @__PURE__ */ createApp({
    init: init2,
    view,
    update,
    next
  });
  var main2 = function __do() {
    var rootNode = runApp(app)(Nothing.value)();
    var container = getElementById("app")();
    return appendChildNode(container)(rootNode)();
  };

  // <stdin>
  main2();
})();
/*! Bundled license information:

browser-split/index.js:
  (*!
   * Cross-Browser Split 1.1.1
   * Copyright 2007-2012 Steven Levithan <stevenlevithan.com>
   * Available under the MIT License
   * ECMAScript compliant, uniform cross-browser split method
   *)
*/
