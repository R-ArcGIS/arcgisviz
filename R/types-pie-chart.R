#' @include types-heat-chart.R
NULL

# S7 classes for the pie chart's series shape (WebChartPieChartSeries), its
# slices, and the legend variant only it has. Source of truth:
# node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts.
#
# A pie config carries no `axes` at all - tt() (dist/chunks/index.js:765)
# omits the key that every other default config sets.

library(S7)

#' WebChartPieChartLegend
#'
#' A pie's legend, which can also carry each slice's value and percentage.
#' A pie always draws a legend - it is the only key to the slices.
#'
#' @name WebChartPieChartLegend
#' @return An object of class `WebChartPieChartLegend`.
#' @examples
#' WebChartPieChartLegend(
#'   type = "chartLegend",
#'   displayCategory = TRUE,
#'   displayPercentage = TRUE
#' )
#' @export
WebChartPieChartLegend := new_class(
  WebChartLegend,
  properties = list(
    displayCategory = s7x::class_boolean,
    displayNumericValue = s7x::class_boolean,
    displayPercentage = s7x::class_boolean,
    labelMaxWidth = s7x::class_float,
    valueLabelMaxWidth = s7x::class_float
  )
)

#' WebChartPieChartTick
#'
#' The leader line joining a slice to its label when the label sits outside
#' the pie.
#'
#' @name WebChartPieChartTick
#' @return An object of class `WebChartPieChartTick`.
#' @examples
#' WebChartPieChartTick(
#'   type = "chartPieChartTick",
#'   visible = TRUE,
#'   lineSymbol = ISimpleLineSymbol(width = 0.5)
#' )
#' @export
WebChartPieChartTick := new_class(
  properties = list(
    type = s7x::class_string,
    visible = s7x::class_boolean,
    lineSymbol = s7x::property_union(ISimpleLineSymbol, NULL, default = NULL)
  )
)

#' WebChartPieChartSlice
#'
#' Per-slice styling. Modelled, but nothing in the public API sets it -
#' [set_color()] already does what this would.
#'
#' @name WebChartPieChartSlice
#' @return An object of class `WebChartPieChartSlice`.
#' @examples
#' WebChartPieChartSlice(
#'   sliceId = "Adelie",
#'   label = "Adelie",
#'   fillSymbol = ISimpleFillSymbol(
#'     color = Color(r = 78, g = 121, b = 167, a = 1)
#'   )
#' )
#' @export
WebChartPieChartSlice := new_class(
  properties = list(
    sliceId = s7x::class_string,
    originalLabel = S7::class_any,
    label = s7x::class_string,
    fillSymbol = s7x::property_union(ISimpleFillSymbol, NULL, default = NULL)
  )
)

#' WebChartPieChartGroupSlice
#'
#' Folds every slice under a percentage threshold into a single "Other". A
#' [WebChartPieChartSlice()], so it styles itself the same way. Modelled and
#' not yet reachable from the public API.
#'
#' @name WebChartPieChartGroupSlice
#' @return An object of class `WebChartPieChartGroupSlice`.
#' @examples
#' WebChartPieChartGroupSlice(label = "Other", percentageThreshold = 5)
#' @export
WebChartPieChartGroupSlice := new_class(
  WebChartPieChartSlice,
  properties = list(
    percentageThreshold = s7x::property_range(0, 100),
    dataLabels = s7x::property_union(WebChartText, NULL, default = NULL)
  )
)

#' WebChartPieChartSeries
#'
#' The pie's series. It reads the same query shape a bar chart's does, so
#' [set_stat()] works unchanged - what differs is that a pie sends no axes at
#' all, and carries the dial geometry (`innerRadius`, the angles) itself.
#'
#' @name WebChartPieChartSeries
#' @return An object of class `WebChartPieChartSeries`.
#' @examples
#' WebChartPieChartSeries(
#'   type = "pieSeries",
#'   id = "series0",
#'   x = "species",
#'   y = "count_0",
#'   innerRadius = 55,
#'   displayCategoryOnDataLabel = TRUE,
#'   displayPercentageOnDataLabel = TRUE
#' )
#' @export
WebChartPieChartSeries := new_class(
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
    y = s7x::class_string,
    innerRadius = s7x::property_range(0, 100),
    startAngle = s7x::class_float,
    endAngle = s7x::class_float,
    fillSymbol = s7x::property_union(ISimpleFillSymbol, NULL, default = NULL),
    displayCategoryOnDataLabel = s7x::class_boolean,
    displayNumericValueOnDataLabel = s7x::class_boolean,
    displayPercentageOnDataLabel = s7x::class_boolean,
    displayCategoryOnTooltip = s7x::class_boolean,
    displayNumericValueOnTooltip = s7x::class_boolean,
    displayPercentageOnTooltip = s7x::class_boolean,
    numericValueFormat = s7x::property_union(
      NumberFormatOptions,
      NULL,
      default = NULL
    ),
    percentValueFormat = s7x::property_union(
      NumberFormatOptions,
      NULL,
      default = NULL
    ),
    valuePrefix = s7x::class_string,
    valueSuffix = s7x::class_string,
    percentagePrefix = s7x::class_string,
    percentageSuffix = s7x::class_string,
    dataLabelsCharacterLimit = s7x::class_float,
    ticks = s7x::property_union(WebChartPieChartTick, NULL, default = NULL),
    dataLabelsInside = s7x::class_boolean,
    dataLabelsOffset = s7x::class_float,
    alignDataLabels = s7x::class_boolean,
    optimizeDataLabelsOverlapping = s7x::class_boolean,
    sliceGrouping = s7x::property_union(
      WebChartPieChartGroupSlice,
      NULL,
      default = NULL
    ),
    slices = class_list
  )
)
