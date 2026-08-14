import "widgets";
import { defineCustomElements as defineChartElements } from "@arcgis/charts-components/loader";
import { createModel } from "@arcgis/charts-components";

// Registers the <arcgis-chart> custom element (lazy-loads its chunk on
// first use). See srcjs/README.md for the overall architecture: R builds
// a self-contained `iLayer` (feature collection) JSON via arcgisutils and
// the full chart `config` (the WebChart shape) from its S7 type layer, and
// hands both to createModel(). The chart type is derived from
// config.series[0].type - there is no separate chartType to pass.
defineChartElements(window);

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
          var model = await createModel({
            iLayer: x.iLayer,
            config: x.config,
          });

          chartEl.layer = model.getLayer();
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
