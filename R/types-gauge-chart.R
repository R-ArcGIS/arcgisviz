#' @include types-pie-chart.R
NULL

# S7 classes for the gauge's series shape (WebChartGaugeSeries), its axis and
# needle, and its own WebChart subtype (WebGaugeChart). Source of truth:
# node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts.
#
# A gauge config carries exactly one axis (ce(), dist/chunks/index.js:463)
# and reads its value off `series[0].x`, not a `y`.

library(S7)

#' ValueConversion
#'
#' A linear rescaling applied to a gauge's reading before it is drawn.
#'
#' @name ValueConversion
#' @return An object of class `ValueConversion`.
#' @examples
#' # Grams to kilograms.
#' ValueConversion(factor = 0.001, offset = 0)
#' @export
ValueConversion := new_class(
  properties = list(
    factor = s7x::class_float,
    offset = s7x::class_float
  )
)

#' WebChartGaugeAxisTick
#'
#' @name WebChartGaugeAxisTick
#' @return An object of class `WebChartGaugeAxisTick`.
#' @examples
#' WebChartGaugeAxisTick(type = "chartGaugeAxisTick", visible = TRUE)
#' @export
WebChartGaugeAxisTick := new_class(
  properties = list(
    type = s7x::class_string,
    visible = s7x::class_boolean
  )
)

#' WebChartNeedle
#'
#' The needle drawn over a gauge's fill. `set_gauge(needle = FALSE)` is the
#' friendly way to turn it off.
#'
#' @name WebChartNeedle
#' @return An object of class `WebChartNeedle`.
#' @examples
#' WebChartNeedle(
#'   type = "chartGaugeNeedle",
#'   visible = TRUE,
#'   innerRadius = 20,
#'   displayPin = TRUE,
#'   symbol = ISimpleFillSymbol(color = Color(r = 51, g = 51, b = 51, a = 1))
#' )
#' @export
WebChartNeedle := new_class(
  properties = list(
    type = s7x::class_string,
    visible = s7x::class_boolean,
    symbol = s7x::property_union(ISimpleFillSymbol, NULL, default = NULL),
    startWidth = s7x::class_float,
    endWidth = s7x::class_float,
    innerRadius = s7x::property_range(0, 100),
    displayPin = s7x::class_boolean
  )
)

#' WebChartGaugeFixedProgressBandsBands
#'
#' The two symbols a gauge's progress bands are drawn with - the filled
#' portion and the track behind it.
#'
#' @name WebChartGaugeFixedProgressBandsBands
#' @return An object of class `WebChartGaugeFixedProgressBandsBands`.
#' @examples
#' WebChartGaugeFixedProgressBandsBands(
#'   target = ISimpleFillSymbol(color = Color(r = 78, g = 121, b = 167, a = 1)),
#'   base = ISimpleFillSymbol(color = Color(r = 230, g = 230, b = 230, a = 1))
#' )
#' @export
WebChartGaugeFixedProgressBandsBands := new_class(
  properties = list(
    target = s7x::property_union(ISimpleFillSymbol, NULL, default = NULL),
    base = s7x::property_union(ISimpleFillSymbol, NULL, default = NULL)
  )
)

#' WebChartGaugeFixedProgressBands
#'
#' Modelled, but nothing in the public API sets it - progress bands replace
#' the axis guides this package does not build either.
#'
#' @name WebChartGaugeFixedProgressBands
#' @return An object of class `WebChartGaugeFixedProgressBands`.
#' @examples
#' WebChartGaugeFixedProgressBands(
#'   type = "chartGaugeFixedProgressBands",
#'   visible = TRUE,
#'   bands = WebChartGaugeFixedProgressBandsBands(
#'     target = ISimpleFillSymbol(
#'       color = Color(r = 78, g = 121, b = 167, a = 1)
#'     )
#'   )
#' )
#' @export
WebChartGaugeFixedProgressBands := new_class(
  properties = list(
    type = s7x::class_string,
    visible = s7x::class_boolean,
    bands = s7x::property_union(
      WebChartGaugeFixedProgressBandsBands,
      NULL,
      default = NULL
    )
  )
)

#' WebChartGaugeAxis
#'
#' A [WebChartAxis()] carrying the needle. A gauge has exactly one axis, and
#' [set_axis()]`("x")` is it.
#'
#' @name WebChartGaugeAxis
#' @return An object of class `WebChartGaugeAxis`.
#' @examples
#' WebChartGaugeAxis(
#'   type = "chartAxis",
#'   minimum = 0,
#'   maximum = 250,
#'   needle = WebChartNeedle(visible = TRUE),
#'   ticks = WebChartGaugeAxisTick(visible = TRUE)
#' )
#' @export
WebChartGaugeAxis := new_class(
  WebChartAxis,
  properties = list(
    innerLabel = s7x::property_union(WebChartText, NULL, default = NULL),
    needle = s7x::property_union(WebChartNeedle, NULL, default = NULL),
    ticks = s7x::property_union(WebChartGaugeAxisTick, NULL, default = NULL),
    labelsIncrement = s7x::class_float,
    onlyShowFirstAndLastLabels = s7x::class_boolean,
    minimumValueConversion = s7x::property_union(
      ValueConversion,
      NULL,
      default = NULL
    ),
    maximumValueConversion = s7x::property_union(
      ValueConversion,
      NULL,
      default = NULL
    ),
    # A field name on a feature gauge; either that or an IStatisticDefinition
    # on a statistic gauge.
    minimumFromField = s7x::property_union(
      IStatisticDefinition,
      s7x::class_string
    ),
    maximumFromField = s7x::property_union(
      IStatisticDefinition,
      s7x::class_string
    ),
    progressBands = s7x::property_union(
      WebChartGaugeFixedProgressBands,
      NULL,
      default = NULL
    )
  )
)

#' WebChartGaugeSeries
#'
#' The gauge's series. Its value rides `x`, not `y`, and `featureIndex` picks
#' a single row instead of aggregating - the spec indexes from zero where
#' [set_gauge()]'s `feature` counts from one.
#'
#' @name WebChartGaugeSeries
#' @return An object of class `WebChartGaugeSeries`.
#' @examples
#' WebChartGaugeSeries(
#'   type = "gaugeSeries",
#'   id = "series0",
#'   x = "AVG_body_mass_0"
#' )
#'
#' # Reading the first row verbatim rather than a statistic.
#' WebChartGaugeSeries(type = "gaugeSeries", x = "body_mass", featureIndex = 0)
#' @export
WebChartGaugeSeries := new_class(
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
    valueConversion = s7x::property_union(
      ValueConversion,
      NULL,
      default = NULL
    ),
    featureIndex = s7x::class_float
  )
)

#' WebGaugeChart
#'
#' A [WebChart()] with the dial's own geometry. `subType` picks the source:
#' `statisticGauge` reduces the whole layer, `featureGauge` reads one row.
#'
#' @name WebGaugeChart
#' @return An object of class `WebGaugeChart`.
#' @examples
#' WebGaugeChart(
#'   version = "18.1.0",
#'   type = "gauge",
#'   innerRadius = 70,
#'   startAngle = -180,
#'   endAngle = 0,
#'   subType = GaugeChartSubTypes("statisticGauge")
#' )
#'
#' # Built for you by the public API.
#' arc_gauge(datasets::penguins, body_mass, stat = "mean")@webchart
#' @export
WebGaugeChart := new_class(
  WebChart,
  properties = list(
    innerRadius = s7x::class_float,
    startAngle = s7x::class_float,
    endAngle = s7x::class_float,
    subType = GaugeChartSubTypes
  )
)
