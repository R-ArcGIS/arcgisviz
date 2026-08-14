import "widgets";
import { defineCustomElements as defineChartElements } from "@arcgis/charts-components/loader";
import { createModel } from "@arcgis/charts-components";

// R sends a sparse config; the model supplies the defaults (a WebChart
// needs a full axes/labels/symbol tree or the engine throws "There are no
// X axes on chart"). See srcjs/README.md.
defineChartElements(window);

// Arrays merge element-wise so a sparse series layers onto the default
// series instead of replacing it. A null value deletes the key outright -
// R's only way to unset a default (e.g. the default count aggregation on
// series.query, which stat = "identity" has to be rid of).
function deepMerge(target, source) {
  if (
    source === null ||
    typeof source !== "object" ||
    target === null ||
    typeof target !== "object"
  ) {
    return source;
  }

  if (Array.isArray(source) || Array.isArray(target)) {
    if (!Array.isArray(source) || !Array.isArray(target)) {
      return source;
    }
    return source.map(function (item, i) {
      return i < target.length ? deepMerge(target[i], item) : item;
    });
  }

  var out = Object.assign({}, target);
  Object.keys(source).forEach(function (key) {
    if (source[key] === null) {
      delete out[key];
    } else {
      out[key] = deepMerge(target[key], source[key]);
    }
  });
  return out;
}

HTMLWidgets.widget({
  name: "arcgisChart",

  type: "output",

  factory: function (el, width, height) {
    var chartEl = document.createElement("arcgis-chart");
    chartEl.style.display = "block";
    chartEl.style.width = "100%";
    chartEl.style.height = "100%";
    el.appendChild(chartEl);

    return {
      renderValue: async function (x) {
        try {
          // Build defaults first, merge R's sparse config over them, then
          // create the real model from the complete config. Assigning
          // `model.config` post-setup instead re-adds series before axes
          // ("There are no X axes on chart").
          var defaults = await createModel({
            iLayer: x.iLayer,
            chartType: x.chartType,
          });

          var model = await createModel({
            iLayer: x.iLayer,
            config: deepMerge(defaults.config, x.config),
          });

          // `layer` is a getter (WithLayer); there is no getLayer() method.
          chartEl.layer = model.layer;
          chartEl.model = model;
        } catch (err) {
          el.innerHTML =
            "<pre>arcgisChart error: " +
            (err && err.message ? err.message : String(err)) +
            "</pre>";
        }
      },

      resize: function (width, height) {
        // <arcgis-chart> fills chartEl (100% width/height), which fills
        // el (the htmlwidgets container) - no manual resize needed.
      },
    };
  },
});
