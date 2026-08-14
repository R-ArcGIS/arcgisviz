# S7 classes for the bar chart's JSON config shape (WebChart + a series
# array of WebChartBarChartSeries). Generated from
# data-raw/spec-type-registry.json, scoped to bar-chart-model.json.
#
# Deferred (see data-raw/resolve-spec-types.R deferred_types and prior
# scoping decisions):
#  - WebChart$iLayer (IFeatureLayer) -> class_any. FeatureLayer/FeatureCollection
#    get dedicated attention later.
#  - WebChart$chartRenderer -> class_any. Complex ArcGIS renderer type, out
#    of scope for the chart model itself.
#  - WebChart$legend is spec'd as WebChartLegend | WebChartPieChartLegend;
#    only WebChartLegend is modeled here since WebChartPieChartLegend is
#    pie-chart-only and out of scope for bar-chart-model.
#  - WebChart$series / $axes are plain class_list (no per-element type
#    enforcement) rather than a length- or type-constrained list.
#
# Optional properties (not in the schema's `required` array): scalar/enum
# ones need no special handling - NA already satisfies class_string,
# class_double, class_boolean, and Enum's allow_na. Object-typed optional
# properties get property_union(Type, NULL, default = NULL) since there's
# no NA equivalent for a class instance. WebChartBarChartSeries requires
# id/name/type/x/y; WebChart requires series/type/version - those stay
# strictly typed.

library(S7)

#' @export
WebChartBarChartSeries := new_class(
  properties = list(
    type = s7x::class_string,
    y = s7x::class_string,
    fillSymbol = s7x::property_union(ISimpleFillSymbol, NULL, default = NULL),
    hideOversizedStackedLabels = s7x::class_boolean,
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
    name = s7x::class_string,
    query = s7x::property_union(WebChartSeriesQuery, NULL, default = NULL),
    x = s7x::class_string,
    dataLabels = s7x::property_union(WebChartText, NULL, default = NULL),
    assignToSecondValueAxis = s7x::class_boolean,
    binTemporalData = s7x::class_boolean,
    timeIntervalUnits = WebChartTimeIntervalUnits,
    timeIntervalSize = s7x::class_double,
    timeAggregationType = WebChartTimeAggregationTypes,
    trimIncompleteTimeInterval = s7x::class_boolean,
    nullPolicy = WebChartNullPolicyTypes
  )
)

#' @export
WebChart := new_class(
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
    subTitle = s7x::property_union(WebChartText, NULL, default = NULL),
    footer = s7x::property_union(WebChartText, NULL, default = NULL),
    background = s7x::property_union(Color, NULL, default = NULL),
    theme = s7x::class_string,
    cursorCrosshair = s7x::property_union(
      WebChartCursorCrosshair,
      NULL,
      default = NULL
    ),
    legend = s7x::property_union(WebChartLegend, NULL, default = NULL),
    axes = class_list,
    horizontalAxisLabelsBehavior = WebChartAxisLabelsBehavior,
    verticalAxisLabelsBehavior = WebChartAxisLabelsBehavior,
    series = class_list,
    rotated = s7x::class_boolean,
    stackedType = WebChartStackedKinds,
    colorMatch = s7x::class_boolean,
    chartRenderer = class_any,
    orderOptions = s7x::property_union(
      WebChartOrderOptions,
      NULL,
      default = NULL
    ),
    iLayer = class_any
  )
)
