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
#' @name ValueConversion
#' @export
ValueConversion := new_class(
  properties = list(
    factor = s7x::class_float,
    offset = s7x::class_float
  )
)

#' WebChartGaugeAxisTick
#' @name WebChartGaugeAxisTick
#' @export
WebChartGaugeAxisTick := new_class(
  properties = list(
    type = s7x::class_string,
    visible = s7x::class_boolean
  )
)

#' WebChartNeedle
#' @name WebChartNeedle
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
#' @name WebChartGaugeFixedProgressBandsBands
#' @export
WebChartGaugeFixedProgressBandsBands := new_class(
  properties = list(
    target = s7x::property_union(ISimpleFillSymbol, NULL, default = NULL),
    base = s7x::property_union(ISimpleFillSymbol, NULL, default = NULL)
  )
)

#' WebChartGaugeFixedProgressBands
#' @name WebChartGaugeFixedProgressBands
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
#' @name WebChartGaugeAxis
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
#' @name WebChartGaugeSeries
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
#' @name WebGaugeChart
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
