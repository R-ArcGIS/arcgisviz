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
#' @name WebChartPieChartLegend
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
#' @name WebChartPieChartTick
#' @export
WebChartPieChartTick := new_class(
  properties = list(
    type = s7x::class_string,
    visible = s7x::class_boolean,
    lineSymbol = s7x::property_union(ISimpleLineSymbol, NULL, default = NULL)
  )
)

#' WebChartPieChartSlice
#' @name WebChartPieChartSlice
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
#' @name WebChartPieChartGroupSlice
#' @export
WebChartPieChartGroupSlice := new_class(
  WebChartPieChartSlice,
  properties = list(
    percentageThreshold = s7x::property_range(0, 100),
    dataLabels = s7x::property_union(WebChartText, NULL, default = NULL)
  )
)

#' WebChartPieChartSeries
#' @name WebChartPieChartSeries
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
