import "widgets";
import "@arcgis/map-components/components/arcgis-map";
import FeatureLayer from "@arcgis/core/layers/FeatureLayer.js";
import FeatureSet from "@arcgis/core/rest/support/FeatureSet.js";
import Field from "@arcgis/core/layers/support/Field.js";
import { fromJSON as rendererFromJSON } from "@arcgis/core/renderers/support/jsonUtils.js";

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
  });

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

HTMLWidgets.widget({
  name: "arcgisMap",

  type: "output",

  factory: function (el, width, height) {
    var mapEl = document.createElement("arcgis-map");
    setSize(mapEl, el, width, height);
    el.appendChild(mapEl);

    return {
      renderValue: async function (x) {
        try {
          assign(mapEl, {
            basemap: x.basemap,
            center: x.center,
            zoom: x.zoom,
            extent: x.extent,
          });

          await mapEl.viewOnReady();

          var layers = (x.layers || []).map(featureLayer);
          mapEl.map.addMany(layers);

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
