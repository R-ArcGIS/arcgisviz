# S7 class for the line chart's series shape (WebChartLineChartSeries).
# Generated from data-raw/spec-type-registry.json, scoped to
# line-chart-model.json. Reuses the same root WebChart class as bar/scatter
# (R/types-bar-chart.R) - `series` is an untyped class_list, so any series
# type can go in it.

library(S7)

#' @export
WebChartLineChartSeries := new_class(
  properties = list(
    type = s7x::class_string,
    y = s7x::property_union(S7::class_character, s7x::class_string),
    lineSymbol = s7x::property_union(ISimpleLineSymbol, NULL, default = NULL),
    lineSmoothed = s7x::class_boolean,
    showArea = s7x::class_boolean,
    markerVisible = s7x::class_boolean,
    markerSymbol = s7x::property_union(ISimpleMarkerSymbol, NULL, default = NULL),
    areaColor = s7x::property_union(Color, NULL, default = NULL),
    stackNegativeValuesToBaseline = s7x::class_boolean,
    id = s7x::class_string,
    visible = s7x::class_boolean,
    dataTooltipVisible = s7x::class_boolean,
    dataTooltipReverseColor = s7x::class_boolean,
    dataTooltipValueFormat = s7x::property_union(NumberFormatOptions, NULL, default = NULL),
    dataTooltipPercentFormat = s7x::property_union(NumberFormatOptions, NULL, default = NULL),
    dataTooltipDateFormat = s7x::property_union(DateTimeFormatOptions, NULL, default = NULL),
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
