#' @include types-histogram.R
NULL

# S7 classes for the box plot's series shape (WebChartBoxPlotSeries) and its
# own WebChart subtype (WebBoxPlot). Source of truth:
# node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts.
#
# `y` is `string[] | string` in the spec: one box per numeric field, or one
# per category when `x` groups them.

library(S7)

#' WebChartBoxPlotSeries
#' @name WebChartBoxPlotSeries
#' @export
WebChartBoxPlotSeries := new_class(
  properties = list(
    type = s7x::class_string,
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
    dataTooltipFontSize = s7x::class_float,
    name = s7x::class_string,
    query = s7x::property_union(WebChartSeriesQuery, NULL, default = NULL),
    x = s7x::class_string,
    dataLabels = s7x::property_union(WebChartText, NULL, default = NULL),
    assignToSecondValueAxis = s7x::class_boolean,
    y = S7::class_character,
    fillSymbol = s7x::property_union(ISimpleFillSymbol, NULL, default = NULL)
  )
)

#' WebBoxPlot
#' @name WebBoxPlot
#' @export
WebBoxPlot := new_class(
  WebChart,
  properties = list(
    showOutliers = s7x::class_boolean,
    standardizeValues = s7x::class_boolean,
    showMean = s7x::class_boolean
  )
)
