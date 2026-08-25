import "widgets";
import "@arcgis/map-components/components/arcgis-map";
import FeatureLayer from "@arcgis/core/layers/FeatureLayer.js";
import FeatureSet from "@arcgis/core/rest/support/FeatureSet.js";
import Field from "@arcgis/core/layers/support/Field.js";
import PopupTemplate from "@arcgis/core/PopupTemplate.js";
import { fromJSON as rendererFromJSON } from "@arcgis/core/renderers/support/jsonUtils.js";
import { debounce } from "@arcgis/core/core/promiseUtils.js";
import { watch } from "@arcgis/core/core/reactiveUtils.js";
import { webMercatorToGeographic } from "@arcgis/core/geometry/support/webMercatorUtils.js";
import SelectionOperation from "@arcgis/core/views/selection/SelectionOperation.js";

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

// One import() per component, written out rather than built from the name:
// a template literal makes webpack bundle all 179 of them. Each becomes its
// own chunk, so a map pays only for the widgets it asks for.
var COMPONENTS = {
  "arcgis-basemap-gallery": function () {
    return import("@arcgis/map-components/components/arcgis-basemap-gallery");
  },
  "arcgis-basemap-toggle": function () {
    return import("@arcgis/map-components/components/arcgis-basemap-toggle");
  },
  "arcgis-bookmarks": function () {
    return import("@arcgis/map-components/components/arcgis-bookmarks");
  },
  "arcgis-area-measurement-2d": function () {
    return import(
      "@arcgis/map-components/components/arcgis-area-measurement-2d"
    );
  },
  "arcgis-compass": function () {
    return import("@arcgis/map-components/components/arcgis-compass");
  },
  "arcgis-distance-measurement-2d": function () {
    return import(
      "@arcgis/map-components/components/arcgis-distance-measurement-2d"
    );
  },
  "arcgis-editor": function () {
    return import("@arcgis/map-components/components/arcgis-editor");
  },
  "arcgis-coordinate-conversion": function () {
    return import(
      "@arcgis/map-components/components/arcgis-coordinate-conversion"
    );
  },
  "arcgis-fullscreen": function () {
    return import("@arcgis/map-components/components/arcgis-fullscreen");
  },
  "arcgis-home": function () {
    return import("@arcgis/map-components/components/arcgis-home");
  },
  "arcgis-layer-list": function () {
    return import("@arcgis/map-components/components/arcgis-layer-list");
  },
  "arcgis-legend": function () {
    return import("@arcgis/map-components/components/arcgis-legend");
  },
  "arcgis-locate": function () {
    return import("@arcgis/map-components/components/arcgis-locate");
  },
  "arcgis-scale-bar": function () {
    return import("@arcgis/map-components/components/arcgis-scale-bar");
  },
  "arcgis-search": function () {
    return import("@arcgis/map-components/components/arcgis-search");
  },
  "arcgis-sketch": function () {
    return import("@arcgis/map-components/components/arcgis-sketch");
  },
  "arcgis-track": function () {
    return import("@arcgis/map-components/components/arcgis-track");
  },
  "arcgis-zoom": function () {
    return import("@arcgis/map-components/components/arcgis-zoom");
  },
};

var ESRI_GEOMETRY = {
  point: "esriGeometryPoint",
  multipoint: "esriGeometryMultipoint",
  polyline: "esriGeometryPolyline",
  polygon: "esriGeometryPolygon",
  extent: "esriGeometryEnvelope",
};

// Drawn geometry is in the view's spatial reference, which is Web Mercator
// for every basemap the SDK ships, so R would get metres.
function geographic(geometry) {
  var sr = geometry && geometry.spatialReference;
  return sr && sr.isWebMercator ? webMercatorToGeographic(geometry) : geometry;
}

// A feature set is what arcgisutils::parse_esri_json() reads, and it travels
// as a string so R parses it rather than Shiny's jsonlite.
function featureSetJson(graphics) {
  var drawn = graphics
    .map(function (graphic, i) {
      var geometry = geographic(graphic.geometry);
      if (!geometry) return null;
      return {
        geometry: geometry.toJSON(),
        attributes: { object_id: i + 1 },
      };
    })
    .filter(Boolean);

  if (!drawn.length) return null;
  var first = geographic(graphics[0].geometry);

  return JSON.stringify({
    geometryType: ESRI_GEOMETRY[first.type],
    spatialReference: first.spatialReference.toJSON(),
    features: drawn,
  });
}

function editedIds(results) {
  return (results || []).map(function (result) {
    return result.objectId;
  });
}

// Guarded rather than called by name: `mode` arrives from the wire, and
// manager[mode] would otherwise reach any method on the manager.
var SELECTION_MODES = { replace: 1, add: 1, remove: 1, toggle: 1 };

// A selection identifier is an object id for a layer that has one and a
// Graphic for a layer that does not (views/selection/types.d.ts:78).
function selectionId(layer, item) {
  return item && typeof item === "object"
    ? item.attributes[layer.objectIdField]
    : item;
}

function selectionPayload(manager) {
  var layers = manager.selections.map(function (entry) {
    return {
      layer: entry.layer.id,
      objectIds: entry.selection.map(function (item) {
        return selectionId(entry.layer, item);
      }),
    };
  });

  return {
    count: layers.reduce(function (n, entry) {
      return n + entry.objectIds.length;
    }, 0),
    layers: layers,
  };
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
      widgets: {},
      watches: {},
      selectable: {},
      operation: null,
      hovered: null,
      ready: null,
      subscribed: false,
      viewTimer: null,
    };

    // The SelectionManager owns the selection set, its highlight, and the
    // change event. It is beta in 5.1, so its absence is worth a real error.
    function selectionManager() {
      var manager = mapEl.selectionManager;
      if (!manager) {
        throw new Error("this @arcgis/core build has no selectionManager");
      }
      return manager;
    }

    // mapEl.map is not there until the view resolves, and a proxy message can
    // arrive before renderValue has finished. Everything awaits this.
    function whenReady() {
      if (!state.ready) state.ready = mapEl.viewOnReady();
      return state.ready;
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
        if (existing) mapEl.map.remove(existing);
        state.layers[layer.id] = layer;
        subscribeEdits(layer);
      });
      mapEl.map.addMany(layers);
      return layers;
    }

    function removeLayers(ids) {
      targetLayers(ids).forEach(function (layer) {
        mapEl.map.remove(layer);
        delete state.layers[layer.id];
        delete state.selectable[layer.id];
      });
      hideTooltip();
      syncSelectable();
    }

    // The manager only selects in layers it holds as sources, and a layer
    // added later is not one until this runs.
    function syncSelectable(ids) {
      (Array.isArray(ids) ? ids : []).forEach(function (id) {
        state.selectable[id] = true;
      });
      if (mapEl.selectionManager) mapEl.selectionManager.syncSources();
    }

    function applySelection(ids, objectIds, mode) {
      if (!SELECTION_MODES[mode]) {
        throw new Error("unknown selection mode: " + mode);
      }
      var manager = selectionManager();
      var layers = targetLayers(ids);

      if (!objectIds || !objectIds.length) {
        if (!ids) return manager.clear();
        return layers.forEach(function (layer) {
          manager.replace(layer, []);
        });
      }

      layers.forEach(function (layer) {
        manager[mode](layer, objectIds);
      });
    }

    // The tool is live on the view the moment the operation exists, and each
    // one is single use (SelectionOperation.d.ts:57).
    function selectBy(payload) {
      if (state.operation && !state.operation.completed) {
        state.operation.cancel();
      }

      var operation = new SelectionOperation({
        view: mapEl.view,
        selectionManager: selectionManager(),
        createTool: payload.createTool,
        mode: payload.mode,
        type: payload.type,
        sources: payload.ids ? targetLayers(payload.ids) : undefined,
      });

      operation.on("complete", function () {
        state.operation = null;
      });
      state.operation = operation;
    }

    // A slotted child of <arcgis-map> finds the map itself, so nothing here
    // sets referenceElement or view.
    async function addWidgets(list) {
      var specs = Array.isArray(list) ? list : [];
      for (var i = 0; i < specs.length; i++) {
        var spec = specs[i];
        var loader = COMPONENTS[spec.component];
        if (!loader) throw new Error("unknown map widget: " + spec.component);
        await loader();

        removeWidgets([spec.component]);
        var node = document.createElement(spec.component);
        node.slot = spec.position;
        assign(node, spec.props || {});
        mapEl.appendChild(node);
        state.widgets[spec.component] = node;
        subscribeWidget(spec.component, node);
      }
    }

    // Only the tools have anything to report. Everything else on the map is
    // furniture the reader drives and R never hears about.
    function subscribeWidget(component, node) {
      if (component === "arcgis-sketch") return subscribeSketch(node);
      if (component.indexOf("-measurement-2d") === -1) return;

      subscribeMeasurement(component, node).catch(function (err) {
        shinyInput(el, "error", {
          kind: "widget",
          method: component,
          detail: err && err.message ? err.message : String(err),
        });
      });
    }

    // The sketch component keeps its own graphics layer, so the payload is
    // everything currently drawn rather than the one graphic that changed.
    function subscribeSketch(node) {
      var report = function (action) {
        var graphics = node.layer ? node.layer.graphics.toArray() : [];
        shinyInput(el, "sketch", {
          action: action,
          count: graphics.length,
          features: featureSetJson(graphics),
        });
      };

      // create and update fire continuously while the shape is being drawn.
      node.addEventListener("arcgisCreate", function (event) {
        if (event.detail.state === "complete") report("create");
      });
      node.addEventListener("arcgisUpdate", function (event) {
        if (event.detail.state === "complete") report("update");
      });
      node.addEventListener("arcgisDelete", function () {
        report("delete");
      });
      ["arcgisUndo", "arcgisRedo"].forEach(function (name) {
        node.addEventListener(name, function () {
          report(name === "arcgisUndo" ? "undo" : "redo");
        });
      });
    }

    // The result lives on the analysis *view*, which exists only once the
    // component has made its analysis and the map has a view for it.
    async function subscribeMeasurement(component, node) {
      var tool = component.indexOf("area") !== -1 ? "area" : "distance";
      await node.componentOnReady();
      var analysisView = await mapEl.whenAnalysisView(node.analysis);

      state.watches[component] = watch(
        function () {
          return analysisView.result;
        },
        function (result) {
          if (!result) return shinyInput(el, "measurement", null);
          shinyInput(el, "measurement", {
            tool: tool,
            mode: result.mode,
            length: result.length || result.perimeter || null,
            area: result.area || null,
          });
        },
      );
    }

    // Edits reach R from the layer, not the editor: applyEdits() reports
    // object ids, and the features themselves are queried back out.
    function subscribeEdits(layer) {
      layer.on("edits", async function (event) {
        var added = editedIds(event.addedFeatures);
        var updated = editedIds(event.updatedFeatures);
        var deleted = editedIds(event.deletedFeatures);
        var changed = added.concat(updated);

        var set = changed.length
          ? await layer.queryFeatures({
              objectIds: changed,
              outFields: ["*"],
              returnGeometry: true,
            })
          : null;

        shinyInput(el, "edits", {
          layer: layer.id,
          added: added,
          updated: updated,
          deleted: deleted,
          features: set ? JSON.stringify(set.toJSON()) : null,
        });
      });
    }

    function removeWidgets(components) {
      var wanted = Array.isArray(components)
        ? components
        : Object.keys(state.widgets);

      wanted.forEach(function (component) {
        var node = state.widgets[component];
        if (!node) return;

        // The watch outlives the element, and reading a destroyed analysis
        // view's result throws.
        var handle = state.watches[component];
        if (handle) handle.remove();
        delete state.watches[component];

        node.remove();
        delete state.widgets[component];
      });
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

      if (mapEl.selectionManager) {
        mapEl.selectionManager.on("selection-change", function () {
          shinyInput(el, "selection", selectionPayload(mapEl.selectionManager));
        });
      }

      mapEl.addEventListener("arcgisViewClick", async function (event) {
        var point = event.detail.mapPoint;
        var response = await mapEl.hitTest(event.detail);
        var hit = hitGraphic(response, state.layers);

        // Toggling is what a click means on a selectable layer; clicking the
        // background is left alone so a selection is never lost by accident.
        if (hit && state.selectable[hit.layer.id]) {
          selectionManager().toggle(hit.layer, [
            hit.graphic.attributes[hit.layer.objectIdField],
          ]);
        }

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
            if (payload.highlight) mapEl.highlights = payload.highlight;
            if (payload.layers) await addLayers(payload.layers);
            syncSelectable(payload.selectable);
            await addWidgets(payload.widgets);
          } else if (msg.method === "removeWidget") {
            removeWidgets(payload.components);
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
          } else if (msg.method === "select") {
            applySelection(payload.ids, payload.objectIds, payload.mode);
          } else if (msg.method === "selectBy") {
            selectBy(payload);
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
          if (x.highlight) mapEl.highlights = x.highlight;
          subscribeEvents();

          // A re-render replaces the map's contents rather than adding to
          // whatever the previous one left behind.
          removeLayers(null);
          removeWidgets(null);
          var layers = await addLayers(x.layers || []);
          syncSelectable(x.selectable);
          await addWidgets(x.widgets);

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
