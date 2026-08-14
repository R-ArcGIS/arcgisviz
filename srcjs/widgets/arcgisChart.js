import "widgets";
import { defineCustomElements as defineChartElements } from "@arcgis/charts-components/loader";
import { createModel } from "@arcgis/charts-components";

// Registers the <arcgis-chart> custom element (lazy-loads its chunk on
// first use). See srcjs/README.md for the overall architecture: R builds
// a self-contained `iLayer` (feature collection) JSON via arcgisutils and
// hands it to this widget along with a chartType + field mappings.
// Serialization of our full S7 WebChart config is deferred - for now we
// only set the x/y field mappings via the model's documented setters.
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
            chartType: x.chartType,
          });

          if (x.xField) {
            await model.setXAxisField(x.xField);
          }
          if (x.yField) {
            await model.setYAxisField(x.yField);
          }

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
