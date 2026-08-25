import "../modules/public-path.js";
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

// R keys the lookup by the mark's own x (and y, for a heat cell), so both
// sides have to stringify it the same way. Dates are refused in R.
function tooltipKey() {
  return Array.prototype.slice.call(arguments).map(String).join("\r");
}

function tooltipRows(tooltip, seriesName, key) {
  if (!tooltip) return "";
  var byMark = tooltip.lookup[seriesName] || tooltip.lookup["*"];
  var values = byMark && byMark[key];
  if (!values) return "";
  return tooltip.labels
    .map(function (label, i) {
      return "\n[bold]" + label + ": [/]" + values[i];
    })
    .join("");
}

// A formatter replaces the default tooltip outright (customElement.js:10012),
// so the x/y lines are ours to rebuild. Each chart type gets its own
// signature; scatter is left alone because its series names fields natively.
function tooltipFormatter(chartType, tooltip, labels) {
  var num = new Intl.NumberFormat();
  var fmt = function (v) {
    return typeof v === "number" ? num.format(v) : String(v);
  };

  if (chartType === "heatChart") {
    return function (value, xValue, yValue) {
      return (
        "[bold]" + labels.x + ": [/]" + fmt(xValue) +
        "\n[bold]" + labels.y + ": [/]" + fmt(yValue) +
        "\n[bold]" + labels.value + ": [/]" + fmt(value) +
        tooltipRows(tooltip, "*", tooltipKey(xValue, yValue))
      );
    };
  }

  return function (props) {
    return (
      "[bold]" + labels.x + ": [/]" + fmt(props.xValue) +
      "\n[bold]" + labels.y + ": [/]" + fmt(props.statValue) +
      tooltipRows(tooltip, props.seriesName, tooltipKey(props.xValue))
    );
  };
}

// The axis titles are what the default tooltip labels its values with
// (customElement.js:10170), and R has already resolved them.
function axisLabels(config) {
  var axes = config.axes || [];
  return {
    x: (axes[0] && axes[0].title && axes[0].title.content.text) || "",
    y: (axes[1] && axes[1].title && axes[1].title.content.text) || "",
    value: "Count",
  };
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

// Payloads carry the whole ChartModel, which is circular and cannot be
// serialized, and selectionIndexes is a Map that stringifies to {}.
function cleanPayload(detail) {
  if (detail === null || typeof detail !== "object") return detail;
  var out = {};
  Object.keys(detail).forEach(function (key) {
    if (key === "model") return;
    var value = detail[key];
    out[key] = value instanceof Map ? Object.fromEntries(value) : value;
  });
  return out;
}

// Object ids and indexes are only computed when asked for, so a selection
// payload arrives empty without these (customElement.d.ts:1267, :1276).
var CHART_EVENTS = {
  arcgisSelectionComplete: "selection",
  arcgisLegendItemVisibilityChange: "legend",
  arcgisAxesMinMaxChange: "axes",
  arcgisSeriesColorChange: "colors",
  arcgisSeriesOrder: "series_order",
  arcgisUpdateComplete: "status",
  arcgisDataProcessComplete: "data",
};

var ERROR_EVENTS = [
  "arcgisRuntimeError",
  "arcgisDataProcessError",
  "arcgisBadDataWarningRaise",
];

// Every event lands on one input named by the output id, so a chart rendered
// as arcgisChartOutput("my_chart") reports input$my_chart$selection. el.id is
// already namespaced, so this is what a module reads too.
//
// The object accumulates: a status update does not wipe out the selection
// beside it. "event" priority means an identical event still fires.
function subscribeEvents(chartEl, el) {
  if (!HTMLWidgets.shinyMode || !el.id) return;
  var events = {};

  var report = function (name, value) {
    events[name] = value;
    Shiny.setInputValue(el.id, Object.assign({}, events), {
      priority: "event",
    });
  };

  Object.keys(CHART_EVENTS).forEach(function (name) {
    chartEl.addEventListener(name, function (event) {
      report(CHART_EVENTS[name], cleanPayload(event.detail));
    });
  });

  ERROR_EVENTS.forEach(function (name) {
    chartEl.addEventListener(name, function (event) {
      report("error", { kind: name, detail: cleanPayload(event.detail) });
    });
  });
}

if (typeof Shiny !== "undefined" && Shiny.addCustomMessageHandler) {
  Shiny.addCustomMessageHandler("arcgisviz-chart", function (msg) {
    var widget = HTMLWidgets.find("#" + msg.id);
    if (widget && widget.receiveMessage) widget.receiveMessage(msg);
  });
}

HTMLWidgets.widget({
  name: "arcgisChart",

  type: "output",

  factory: function (el, width, height) {
    // No `display` here: `:host` is `flex`, and an inline value outranks it.
    // .chart-wrapper has no height of its own - it stretches as a flex item.
    var chartEl = document.createElement("arcgis-chart");
    setSize(chartEl, el, width, height);
    chartEl.returnSelectionOIDs = true;
    chartEl.returnSelectionIndexes = true;
    el.appendChild(chartEl);
    subscribeEvents(chartEl, el);

    // A proxy resends only the config, so the layer and the defaults it was
    // merged over have to survive between renders.
    var state = { iLayer: null, config: null, chartType: null };

    async function build(iLayer, config, chartType, tooltip) {
      var model = await createModel({ iLayer: iLayer, config: config });
      if (tooltip !== undefined) {
        chartEl.tooltipFormatter = tooltip
          ? tooltipFormatter(chartType, tooltip, axisLabels(config))
          : undefined;
      }
      chartEl.layer = model.layer;
      chartEl.model = model;
    }

    return {
      receiveMessage: async function (msg) {
        try {
          if (msg.method === "config") {
            state.config = deepMerge(state.config, msg.payload.config);
            await build(
              state.iLayer,
              state.config,
              state.chartType,
              msg.payload.tooltip || null,
            );
          } else if (msg.method === "element") {
            Object.assign(chartEl, msg.payload);
          } else if (msg.method === "model") {
            Object.assign(chartEl.model, msg.payload);
          } else if (msg.method === "call") {
            await chartEl[msg.payload.method].apply(chartEl, msg.payload.args);
          }
        } catch (err) {
          console.error("arcgisChart proxy:", err);
        }
      },

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

          state.iLayer = x.iLayer;
          state.chartType = x.chartType;
          state.config = deepMerge(defaults.config, x.config);

          await build(state.iLayer, state.config, x.chartType, x.tooltip || null);
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
