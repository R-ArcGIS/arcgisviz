#' @include types-box-plot.R
NULL

# S7 classes for the heat chart's series shape (WebChartHeatChartSeries), its
# heat rules, and its own WebChart subtype (WebHeatChart). Source of truth:
# node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts.
#
# Cells are coloured either by a two-colour gradient or by class breaks,
# selected with `heatRulesType`.

library(S7)

#' WebChartCalendarDatePartsBinning
#' @name WebChartCalendarDatePartsBinning
#' @export
WebChartCalendarDatePartsBinning := new_class(
  properties = list(
    trimIncompleteTimeInterval = s7x::class_boolean,
    start = s7x::class_double,
    end = s7x::class_double,
    offset = s7x::property_union(
      WebChartTemporalBinningOffset,
      NULL,
      default = NULL
    ),
    type = s7x::class_string,
    unit = WebChartCalendarDatePartsUnits
  )
)

#' WebChartHeatChartGradient
#' @name WebChartHeatChartGradient
#' @export
WebChartHeatChartGradient := new_class(
  properties = list(
    colorList = class_list,
    minValue = s7x::class_double,
    maxValue = s7x::class_double,
    outsideRangeLowerColor = s7x::property_union(Color, NULL, default = NULL),
    outsideRangeUpperColor = s7x::property_union(Color, NULL, default = NULL)
  )
)

#' WebChartHeatChartHeatClassBreaksColorRampInfo
#' @name WebChartHeatChartHeatClassBreaksColorRampInfo
#' @export
WebChartHeatChartHeatClassBreaksColorRampInfo := new_class(
  properties = list(
    name = s7x::class_string,
    flipped = s7x::class_boolean
  )
)

#' WebChartHeatChartHeatClassBreaks
#' @name WebChartHeatChartHeatClassBreaks
#' @export
WebChartHeatChartHeatClassBreaks := new_class(
  properties = list(
    breaksCount = s7x::class_double,
    classificationMethod = WebChartClassBreakTypes,
    colorRampInfo = s7x::property_union(
      WebChartHeatChartHeatClassBreaksColorRampInfo,
      NULL,
      default = NULL
    )
  )
)

#' WebChartHeatChartEmptyCell
#' @name WebChartHeatChartEmptyCell
#' @export
WebChartHeatChartEmptyCell := new_class(
  properties = list(
    text = s7x::class_string,
    symbol = s7x::property_union(ISimpleFillSymbol, NULL, default = NULL)
  )
)

#' WebChartHeatChartSeries
#' @name WebChartHeatChartSeries
#' @export
WebChartHeatChartSeries := new_class(
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
    y = s7x::class_string,
    xTemporalBinning = s7x::property_union(
      WebChartCalendarDatePartsBinning,
      NULL,
      default = NULL
    ),
    yTemporalBinning = s7x::property_union(
      WebChartCalendarDatePartsBinning,
      NULL,
      default = NULL
    ),
    gridLine = s7x::property_union(ISimpleLineSymbol, NULL, default = NULL),
    heatRulesType = WebChartHeatChartHeatRulesTypes,
    gradientRules = s7x::property_union(
      WebChartHeatChartGradient,
      NULL,
      default = NULL
    ),
    classBreaksRules = s7x::property_union(
      WebChartHeatChartHeatClassBreaks,
      NULL,
      default = NULL
    ),
    emptyCells = s7x::property_union(
      WebChartHeatChartEmptyCell,
      NULL,
      default = NULL
    )
  )
)

#' WebHeatChart
#' @name WebHeatChart
#' @export
WebHeatChart := new_class(
  WebChart,
  properties = list(
    outTimeZone = s7x::class_string,
    firstDayOfWeek = s7x::property_range_discrete(1L, 7L),
    nullPolicy = WebChartNullPolicyTypes,
    hideEmptyRowsAndColumns = s7x::class_boolean,
    viewType = WebChartHeatChartViewTypes,
    includeLeapDay = s7x::class_boolean
  )
)
