#' @include types-series-shared.R
NULL

# S7 classes for the bar chart's JSON config shape (WebChart + a series
# array of WebChartBarChartSeries). Source of truth:
# node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts (see
# CLAUDE.md - this used to be generated from data-raw/spec-type-registry.json
# via the now-removed, stale @arcgis/charts-model/@arcgis/charts-spec
# packages).
#
# Deferred (see CLAUDE.md):
#  - WebChart$iLayer (IFeatureLayer | IImageServiceLayer | ...) -> class_any.
#    We build this JSON directly via arcgisutils::as_layer(), not by
#    modeling every live-layer type.
#  - WebChart$chartRenderer -> class_any. Complex ArcGIS renderer type, out
#    of scope for the chart model itself.
#  - WebChart$legend is spec'd as WebChartLegend | WebChartPieChartLegend;
#    only WebChartLegend is modeled here since WebChartPieChartLegend is
#    pie-chart-only and out of scope for bar-chart.
#  - WebChart$series / $axes are plain class_list (no per-element type
#    enforcement) rather than a length- or type-constrained list. The spec
#    actually types $axes as a 1-3 tuple [WebChartAxis, WebChartAxis?,
#    WebChartAxis?] - not modeled that strictly here.
#
# Optional properties (not in the interface's `?`-marked properties): scalar/
# enum ones need no special handling - NA already satisfies class_string,
# class_double, class_boolean, and Enum's allow_na. Object-typed optional
# properties get property_union(Type, NULL, default = NULL) since there's
# no NA equivalent for a class instance. WebChartBarChartSeries requires
# id/name/type/x/y; WebChart requires series/type/version - those stay
# strictly typed.
#
# WebChartBarChartSeries' old flat timeIntervalUnits/timeIntervalSize/
# timeAggregationType/trimIncompleteTimeInterval/nullPolicy properties are
# gone - the current spec nests all of that under binTemporalData +
# temporalBinning (WebChartTemporalBinning, R/types-series-shared.R), via
# the WebChartTemporalSeries mixin. New properties vs. the old
# charts-spec-derived version: hideOversizedSideBySideLabels, nullCategory,
# dataTooltipFontSize (from the shared WebChartSeries base).

library(S7)

#' WebChartBarChartSeries
#' @name WebChartBarChartSeries
#' @export
WebChartBarChartSeries <- new_class(
  "WebChartBarChartSeries",
  properties = list(
    type = s7x::class_string,
    y = s7x::class_string,
    fillSymbol = s7x::property_union(ISimpleFillSymbol, NULL, default = NULL),
    hideOversizedStackedLabels = s7x::class_boolean,
    hideOversizedSideBySideLabels = s7x::class_boolean,
    nullCategory = s7x::property_union(
      WebChartNullCategory,
      NULL,
      default = NULL
    ),
    id = s7x::class_string,
    visible = s7x::class_boolean,
    dataTooltipVisible = s7x::class_boolean,
    dataTooltipReverseColor = s7x::class_boolean,
    dataTooltipValueFormat = s7x::property_union(
      NumberFormatOptions,
      NULL,
      default = NULL
    ),
    dataTooltipPercentFormat = s7x::property_union(
      NumberFormatOptions,
      NULL,
      default = NULL
    ),
    dataTooltipDateFormat = s7x::property_union(
      DateTimeFormatOptions,
      NULL,
      default = NULL
    ),
    dataTooltipFontSize = s7x::class_double,
    name = s7x::class_string,
    query = s7x::property_union(WebChartSeriesQuery, NULL, default = NULL),
    x = s7x::class_string,
    dataLabels = s7x::property_union(WebChartText, NULL, default = NULL),
    assignToSecondValueAxis = s7x::class_boolean,
    binTemporalData = s7x::class_boolean,
    temporalBinning = s7x::property_union(
      WebChartTemporalBinning,
      NULL,
      default = NULL
    )
  )
)

#' WebChart
#' @name WebChart
#' @export
WebChart <- new_class(
  "WebChart",
  properties = list(
    version = s7x::class_string,
    type = s7x::class_string,
    id = s7x::class_string,
    dataFilters = s7x::property_union(
      WebChartDataFilters,
      NULL,
      default = NULL
    ),
    title = s7x::property_union(WebChartText, NULL, default = NULL),
    subtitle = s7x::property_union(WebChartText, NULL, default = NULL),
    footer = s7x::property_union(WebChartText, NULL, default = NULL),
    background = s7x::property_union(Color, NULL, default = NULL),
    cursorCrosshair = s7x::property_union(
      WebChartCursorCrosshair,
      NULL,
      default = NULL
    ),
    legend = s7x::property_union(WebChartLegend, NULL, default = NULL),
    axes = class_list,
    horizontalAxisLabelsBehavior = WebChartLabelBehavior,
    verticalAxisLabelsBehavior = WebChartLabelBehavior,
    series = class_list,
    rotated = s7x::class_boolean,
    stackedType = WebChartStackedKinds,
    colorMatch = s7x::class_boolean,
    chartRenderer = s7x::property_union(
      ISimpleRenderer,
      IUniqueValueRenderer,
      NULL,
      default = NULL
    ),
    orderOptions = s7x::property_union(
      WebChartOrderOptions,
      NULL,
      default = NULL
    ),
    iLayer = class_any
  )
)
