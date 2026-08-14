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

// Pixels, not percentages: amCharts 5 - which useAmCharts5() picks for
// scatter, histogram, radar and heat (customElement.js:18705) - keeps
// whatever size it measured at setup. amCharts 4 (bar, line) doesn't care.
function setSize(chartEl, el, width, height) {
  var w = width > 0 ? width : el.offsetWidth;
  var h = height > 0 ? height : el.offsetHeight;
  chartEl.style.width = w + "px";
  chartEl.style.height = h + "px";
}

HTMLWidgets.widget({
  name: "arcgisChart",

  type: "output",

  factory: function (el, width, height) {
    // No `display` here: `:host` is `flex`, and an inline value outranks it.
    // .chart-wrapper has no height of its own - it stretches as a flex item.
    var chartEl = document.createElement("arcgis-chart");
    setSize(chartEl, el, width, height);
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
        setSize(chartEl, el, width, height);
      },
    };
  },
});
