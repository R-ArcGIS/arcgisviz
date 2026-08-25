import "../modules/public-path.js";
import "widgets";
import "@arcgis/map-components/components/arcgis-map";
import FeatureLayer from "@arcgis/core/layers/FeatureLayer.js";
import FeatureSet from "@arcgis/core/rest/support/FeatureSet.js";
import Field from "@arcgis/core/layers/support/Field.js";
import PopupTemplate from "@arcgis/core/PopupTemplate.js";
import { fromJSON as rendererFromJSON } from "@arcgis/core/renderers/support/jsonUtils.js";
import { debounce } from "@arcgis/core/core/promiseUtils.js";

// Optional properties arrive as absent keys, and assigning `undefined` to an
// autocasting Accessor is not the same as never setting it.
function assign(target, props) {
  Object.keys(props).forEach(function (key) {
    if (props[key] !== undefined && props[key] !== null) {
      target[key] = props[key];
    }
  });
  return target;
}

// `layer` is an IFeatureLayer. FeatureSet.fromJSON does the esriGeometryPoint
// -> "point" normalization and turns Esri feature JSON into Graphics, which is
// what `source` wants.
function featureLayer(layer) {
  var collection = layer.featureCollection.layers[0];
  var def = collection.layerDefinition;
  var set = FeatureSet.fromJSON(collection.featureSet);
  var drawing = def.drawingInfo || {};

  var props = {
    id: layer.id,
    title: layer.title,
    source: set.features,
    fields: def.fields.map(function (field) {
      return Field.fromJSON(field);
    }),
    objectIdField: def.objectIdField,
    geometryType: set.geometryType,
    spatialReference: set.spatialReference,
  };

  assign(props, {
    renderer: drawing.renderer ? rendererFromJSON(drawing.renderer) : undefined,
    opacity: layer.opacity,
    visible: layer.visibility,
    minScale: def.minScale,
    maxScale: def.maxScale,
    popupTemplate: collection.popupInfo
      ? PopupTemplate.fromJSON(collection.popupInfo)
      : undefined,
  });

  // The template is here for its labelled field list, which the hover
  // tooltip reads; a click popup on top of that would say the same thing.
  props.popupEnabled = false;

  return new FeatureLayer(props);
}

// Only when R sent no view of its own. goTo on the union of what loaded is
// the closest thing to a sensible default for client-side data.
async function frameLayers(mapEl, layers) {
  var extents = await Promise.all(
    layers.map(async function (layer) {
      await layer.when();
      return layer.fullExtent;
    }),
  );

  var union = extents.reduce(function (acc, extent) {
    if (!extent) return acc;
    return acc ? acc.union(extent) : extent.clone();
  }, null);

  if (union) await mapEl.goTo(union);
}

function setSize(mapEl, el, width, height) {
  mapEl.style.width = (width > 0 ? width : el.offsetWidth) + "px";
  mapEl.style.height = (height > 0 ? height : el.offsetHeight) + "px";
}

var TOOLTIP_CSS =
  ".arcgisviz-tooltip{position:absolute;z-index:10;pointer-events:none;" +
  "display:none;max-width:20rem;padding:.4rem .55rem;border-radius:3px;" +
  "background:rgba(255,255,255,.96);color:#151515;font-size:.8rem;" +
  "line-height:1.35;box-shadow:0 1px 4px rgba(0,0,0,.35)}" +
  ".arcgisviz-tooltip b{font-weight:600}";

function injectStyles() {
  if (document.getElementById("arcgisviz-tooltip-css")) return;
  var style = document.createElement("style");
  style.id = "arcgisviz-tooltip-css";
  style.textContent = TOOLTIP_CSS;
  document.head.appendChild(style);
}

function escapeHtml(value) {
  return String(value).replace(/[&<>"]/g, function (ch) {
    return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[ch];
  });
}

var numberFormat = new Intl.NumberFormat();
var dateFormat = new Intl.DateTimeFormat(undefined, {
  dateStyle: "medium",
  timeZone: "UTC",
});

// A date field is milliseconds from the epoch (arcgisutils::date_to_ms()),
// with -1 standing in for NA (from_esri_date()), so it cannot be formatted
// as the number it arrives as.
function formatValue(value, type) {
  if (value === null || value === undefined) return "";
  if (type === "date" && typeof value === "number") {
    return value === -1 ? "" : dateFormat.format(new Date(value));
  }
  return typeof value === "number" ? numberFormat.format(value) : String(value);
}

function fieldTypes(layer) {
  var types = {};
  (layer.fields || []).forEach(function (field) {
    types[field.name] = field.type;
  });
  return types;
}

// The hover text comes from the layer's own popupInfo, which is the web map
// spec's name for a labelled field list. R writes it from `tooltip =`.
function tooltipHtml(layer, graphic) {
  var infos = layer.popupTemplate && layer.popupTemplate.fieldInfos;
  if (!infos || !infos.length) return "";
  var types = fieldTypes(layer);
  return infos
    .map(function (info) {
      var label = info.label || info.fieldName;
      var value = formatValue(
        graphic.attributes[info.fieldName],
        types[info.fieldName],
      );
      return "<b>" + escapeHtml(label) + ":</b> " + escapeHtml(value);
    })
    .join("<br>");
}

function placeTooltip(tip, el, x, y) {
  var right = x + 14 + tip.offsetWidth > el.offsetWidth;
  var below = y + 14 + tip.offsetHeight > el.offsetHeight;
  tip.style.left = (right ? x - 14 - tip.offsetWidth : x + 14) + "px";
  tip.style.top = (below ? y - 14 - tip.offsetHeight : y + 14) + "px";
}

function hitGraphic(response, layers) {
  var results = response.results || [];
  for (var i = 0; i < results.length; i++) {
    var hit = results[i];
    if (hit.type === "graphic" && layers[hit.layer && hit.layer.id]) {
      return hit;
    }
  }
  return null;
}

function featurePayload(hit) {
  return {
    layer: hit.layer.id,
    objectId: hit.graphic.attributes[hit.layer.objectIdField],
    attributes: hit.graphic.attributes,
  };
}

function shinyInput(el, name, value) {
  if (!HTMLWidgets.shinyMode || !el.id) return;
  Shiny.setInputValue(el.id + "_" + name, value, { priority: "event" });
}

if (typeof Shiny !== "undefined" && Shiny.addCustomMessageHandler) {
  Shiny.addCustomMessageHandler("arcgisviz-map", function (msg) {
    var widget = HTMLWidgets.find("#" + msg.id);
    if (widget && widget.receiveMessage) widget.receiveMessage(msg);
  });
}

HTMLWidgets.widget({
  name: "arcgisMap",

  type: "output",

  factory: function (el, width, height) {
    injectStyles();
    el.style.position = "relative";

    var mapEl = document.createElement("arcgis-map");
    setSize(mapEl, el, width, height);
    el.appendChild(mapEl);

    var tip = document.createElement("div");
    tip.className = "arcgisviz-tooltip";
    el.appendChild(tip);

    // Layers stay in the closure so a proxy can filter, highlight, or hide
    // one without the data crossing the wire a second time.
    var state = {
      layers: {},
      highlights: {},
      hovered: null,
      ready: null,
      subscribed: false,
      viewTimer: null,
    };

    // mapEl.map is not there until the view resolves, and a proxy message can
    // arrive before renderValue has finished. Everything awaits this.
    function whenReady() {
      if (!state.ready) state.ready = mapEl.viewOnReady();
      return state.ready;
    }

    function dropHighlight(id) {
      var handle = state.highlights[id];
      if (handle) handle.remove();
      delete state.highlights[id];
    }

    function hideTooltip() {
      tip.style.display = "none";
      if (state.hovered !== null) {
        state.hovered = null;
        shinyInput(el, "hover", null);
      }
    }

    async function addLayers(list) {
      var layers = list.map(featureLayer);
      layers.forEach(function (layer) {
        var existing = state.layers[layer.id];
        if (existing) {
          dropHighlight(layer.id);
          mapEl.map.remove(existing);
        }
        state.layers[layer.id] = layer;
      });
      mapEl.map.addMany(layers);
      return layers;
    }

    function removeLayers(ids) {
      targetLayers(ids).forEach(function (layer) {
        dropHighlight(layer.id);
        mapEl.map.remove(layer);
        delete state.layers[layer.id];
      });
      hideTooltip();
    }

    function targetLayers(ids) {
      var wanted = ids || Object.keys(state.layers);
      return wanted
        .map(function (id) {
          return state.layers[id];
        })
        .filter(Boolean);
    }

    // hitTest is async and the pointer moves faster than it resolves;
    // debounce() rejects the superseded calls with AbortError.
    var updateHover = debounce(async function (detail) {
      var response = await mapEl.hitTest(detail, {
        include: targetLayers(null),
      });
      var hit = hitGraphic(response, state.layers);
      if (!hit) return hideTooltip();

      var html = tooltipHtml(hit.layer, hit.graphic);
      if (html) {
        tip.innerHTML = html;
        tip.style.display = "block";
        placeTooltip(tip, el, detail.x, detail.y);
      } else {
        tip.style.display = "none";
      }

      var payload = featurePayload(hit);
      var key = payload.layer + "\r" + payload.objectId;
      if (key !== state.hovered) {
        state.hovered = key;
        shinyInput(el, "hover", payload);
      }
    });

    // arcgisViewChange fires throughout a pan or zoom animation, and each one
    // would be a websocket message. Only the settled view is reported.
    function reportView() {
      if (state.viewTimer) clearTimeout(state.viewTimer);
      state.viewTimer = setTimeout(function () {
        var extent = mapEl.extent;
        shinyInput(el, "view", {
          zoom: mapEl.zoom,
          center: mapEl.center
            ? [mapEl.center.longitude, mapEl.center.latitude]
            : null,
          extent: extent ? extent.toJSON() : null,
        });
      }, 250);
    }

    // renderValue runs again on every re-render; listeners bound twice would
    // send every event twice.
    function subscribeEvents() {
      if (state.subscribed) return;
      state.subscribed = true;

      mapEl.addEventListener("arcgisViewPointerMove", function (event) {
        updateHover(event.detail).catch(function (err) {
          if (err && err.name !== "AbortError") console.error(err);
        });
      });

      mapEl.addEventListener("arcgisViewPointerLeave", hideTooltip);

      mapEl.addEventListener("arcgisViewClick", async function (event) {
        var point = event.detail.mapPoint;
        var response = await mapEl.hitTest(event.detail);
        var hit = hitGraphic(response, state.layers);
        shinyInput(el, "click", {
          longitude: point && point.longitude,
          latitude: point && point.latitude,
          feature: hit ? featurePayload(hit) : null,
        });
      });

      mapEl.addEventListener("arcgisViewChange", reportView);

      ["arcgisLoadError", "arcgisViewReadyError"].forEach(function (name) {
        mapEl.addEventListener(name, function (event) {
          shinyInput(el, "error", { kind: name, detail: String(event.detail) });
        });
      });
    }

    async function highlight(ids, objectIds) {
      var layers = targetLayers(ids);
      for (var i = 0; i < layers.length; i++) {
        var layer = layers[i];
        var handle = state.highlights[layer.id];
        if (handle) handle.remove();
        delete state.highlights[layer.id];
        if (!objectIds || !objectIds.length) continue;
        var view = await mapEl.whenLayerView(layer);
        state.highlights[layer.id] = view.highlight(objectIds);
      }
    }

    return {
      receiveMessage: async function (msg) {
        try {
          await whenReady();
          var payload = JSON.parse(msg.payload);
          if (msg.method === "update") {
            assign(mapEl, {
              basemap: payload.basemap,
              center: payload.center,
              zoom: payload.zoom,
              extent: payload.extent,
            });
            if (payload.layers) await addLayers(payload.layers);
          } else if (msg.method === "remove") {
            removeLayers(payload.ids);
          } else if (msg.method === "layer") {
            targetLayers(payload.ids).forEach(function (layer) {
              assign(layer, payload.props);
            });
          } else if (msg.method === "filter") {
            targetLayers(payload.ids).forEach(function (layer) {
              layer.definitionExpression = payload.where || null;
            });
          } else if (msg.method === "highlight") {
            await highlight(payload.ids, payload.objectIds);
          } else if (msg.method === "goto") {
            var t = payload.target;
            await mapEl.goTo(t.extent || t, payload.options);
          } else if (msg.method === "screenshot") {
            var shot = await mapEl.takeScreenshot({ format: payload.format });
            shinyInput(el, "screenshot", shot.dataUrl);
          }
        } catch (err) {
          console.error("arcgisMap proxy:", err);
          shinyInput(el, "error", {
            kind: "proxy",
            method: msg.method,
            detail: err && err.message ? err.message : String(err),
          });
        }
      },

      renderValue: async function (x) {
        try {
          assign(mapEl, {
            basemap: x.basemap,
            center: x.center,
            zoom: x.zoom,
            extent: x.extent,
          });

          await whenReady();
          subscribeEvents();

          // A re-render replaces the map's contents rather than adding to
          // whatever the previous one left behind.
          removeLayers(null);
          var layers = await addLayers(x.layers || []);

          if (!x.center && !x.extent) await frameLayers(mapEl, layers);
        } catch (err) {
          el.innerHTML =
            "<pre>arcgisMap error: " +
            (err && err.message ? err.message : String(err)) +
            "</pre>";
        }
      },

      resize: function (width, height) {
        setSize(mapEl, el, width, height);
      },
    };
  },
});
