#' @include types-scatter-plot.R
NULL

# S7 class for the line chart's series shape (WebChartLineChartSeries).
# Source of truth: node_modules/@arcgis/charts-components/dist/spec/
# web-chart.d.ts (see CLAUDE.md). Reuses the same root WebChart class as
# bar/scatter (R/types-bar-chart.R) - `series` is an untyped class_list, so
# any series type can go in it.
#
# The old flat timeIntervalUnits/timeIntervalSize/timeAggregationType/
# trimIncompleteTimeInterval/nullPolicy properties are gone - the current
# spec nests all of that under binTemporalData + temporalBinning
# (WebChartTemporalBinning, R/types-series-shared.R), via the
# WebChartTemporalSeries mixin (same restructuring as bar chart's series).
# New properties vs. the old charts-spec-derived version: connectLines,
# nullCategory, dataTooltipFontSize (from the shared WebChartSeries base).
#
# `WebChartRadarChartSeries` is `WebChartLineChartSeries<"radarSeries">` in
# the spec (a generic type-parameter swap on `type` only) - not modeled as
# a separate class since radar charts are out of scope for now.

library(S7)

#' WebChartLineChartSeries
#' @name WebChartLineChartSeries
#' @export
WebChartLineChartSeries <- new_class(
  "WebChartLineChartSeries",
  properties = list(
    type = s7x::class_string,
    y = s7x::property_union(S7::class_character, s7x::class_string),
    lineSymbol = s7x::property_union(ISimpleLineSymbol, NULL, default = NULL),
    lineSmoothed = s7x::class_boolean,
    showArea = s7x::class_boolean,
    markerVisible = s7x::class_boolean,
    markerSymbol = s7x::property_union(
      ISimpleMarkerSymbol,
      NULL,
      default = NULL
    ),
    areaColor = s7x::property_union(Color, NULL, default = NULL),
    stackNegativeValuesToBaseline = s7x::class_boolean,
    connectLines = s7x::class_boolean,
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
