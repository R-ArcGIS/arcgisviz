#' @include types-line-chart.R
NULL

# S7 classes for the histogram's series shape (WebChartHistogramSeries) and
# its overlays. Source of truth:
# node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts.
#
# A histogram bins one numeric field, so the series carries no `y` - the
# frequency axis is derived client-side.

library(S7)

#' HistogramOverlays
#' @name HistogramOverlays
#' @export
HistogramOverlays := new_class(
  properties = list(
    type = s7x::class_string,
    mean = s7x::property_union(WebChartOverlay, NULL, default = NULL),
    median = s7x::property_union(WebChartOverlay, NULL, default = NULL),
    standardDeviation = s7x::property_union(
      WebChartOverlay,
      NULL,
      default = NULL
    ),
    comparisonDistribution = s7x::property_union(
      WebChartOverlay,
      NULL,
      default = NULL
    )
  )
)

#' WebChartHistogramSeries
#' @name WebChartHistogramSeries
#' @export
WebChartHistogramSeries := new_class(
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
    dataTooltipFontSize = s7x::class_double,
    name = s7x::class_string,
    query = s7x::property_union(WebChartSeriesQuery, NULL, default = NULL),
    x = s7x::class_string,
    dataLabels = s7x::property_union(WebChartText, NULL, default = NULL),
    assignToSecondValueAxis = s7x::class_boolean,
    binCount = s7x::class_double,
    overlays = s7x::property_union(HistogramOverlays, NULL, default = NULL),
    dataTransformationType = WebChartDataTransformations,
    fillSymbol = s7x::property_union(ISimpleFillSymbol, NULL, default = NULL)
  )
)
