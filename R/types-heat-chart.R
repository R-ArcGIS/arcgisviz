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
#'
#' Bins a date column by a part of the calendar rather than by an interval -
#' every Monday together, every January together. Modelled, but nothing in
#' the public API sets it: a heat series with this takes the client's calendar
#' branch instead of the matrix one.
#'
#' @name WebChartCalendarDatePartsBinning
#' @return An object of class `WebChartCalendarDatePartsBinning`.
#' @examples
#' WebChartCalendarDatePartsBinning(
#'   type = "calendarDatePartsBinning",
#'   unit = WebChartCalendarDatePartsUnits("dayOfWeek")
#' )
#' @export
WebChartCalendarDatePartsBinning := new_class(
  properties = list(
    trimIncompleteTimeInterval = s7x::class_boolean,
    start = s7x::class_float,
    end = s7x::class_float,
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
#'
#' The two-colour gradient a heat chart shades its cells with. This is what
#' `set_color(palette = )` builds for anything that is not a named Esri ramp.
#'
#' @name WebChartHeatChartGradient
#' @return An object of class `WebChartHeatChartGradient`.
#' @examples
#' WebChartHeatChartGradient(
#'   colorList = list(
#'     Color(r = 255, g = 255, b = 255, a = 1),
#'     Color(r = 0, g = 0, b = 128, a = 1)
#'   )
#' )
#' @export
WebChartHeatChartGradient := new_class(
  properties = list(
    colorList = class_list,
    minValue = s7x::class_float,
    maxValue = s7x::class_float,
    outsideRangeLowerColor = s7x::property_union(Color, NULL, default = NULL),
    outsideRangeUpperColor = s7x::property_union(Color, NULL, default = NULL)
  )
)

#' WebChartHeatChartHeatClassBreaksColorRampInfo
#'
#' Names an Esri colour ramp for the client to generate class breaks from.
#' The ramp travels by *name*: no colours leave R, which is why a named ramp
#' cannot carry an alpha channel.
#'
#' @name WebChartHeatChartHeatClassBreaksColorRampInfo
#' @return An object of class `WebChartHeatChartHeatClassBreaksColorRampInfo`.
#' @examples
#' WebChartHeatChartHeatClassBreaksColorRampInfo(
#'   name = "Heatmap 3",
#'   flipped = FALSE
#' )
#' @export
WebChartHeatChartHeatClassBreaksColorRampInfo := new_class(
  properties = list(
    name = s7x::class_string,
    flipped = s7x::class_boolean
  )
)

#' WebChartHeatChartHeatClassBreaks
#'
#' Shades a heat chart's cells by classed breaks off a named Esri ramp, the
#' branch `set_color(palette = "Heatmap 3")` takes.
#'
#' @name WebChartHeatChartHeatClassBreaks
#' @return An object of class `WebChartHeatChartHeatClassBreaks`.
#' @examples
#' WebChartHeatChartHeatClassBreaks(
#'   breaksCount = 5,
#'   classificationMethod = WebChartClassBreakTypes("equal-interval"),
#'   colorRampInfo = WebChartHeatChartHeatClassBreaksColorRampInfo(
#'     name = "Heatmap 3"
#'   )
#' )
#' @export
WebChartHeatChartHeatClassBreaks := new_class(
  properties = list(
    breaksCount = s7x::class_float,
    classificationMethod = WebChartClassBreakTypes,
    colorRampInfo = s7x::property_union(
      WebChartHeatChartHeatClassBreaksColorRampInfo,
      NULL,
      default = NULL
    )
  )
)

#' WebChartHeatChartEmptyCell
#'
#' How a cell with no rows in it is labelled and drawn.
#'
#' @name WebChartHeatChartEmptyCell
#' @return An object of class `WebChartHeatChartEmptyCell`.
#' @examples
#' WebChartHeatChartEmptyCell(
#'   text = "None",
#'   symbol = ISimpleFillSymbol(color = Color(r = 245, g = 245, b = 245, a = 1))
#' )
#' @export
WebChartHeatChartEmptyCell := new_class(
  properties = list(
    text = s7x::class_string,
    symbol = s7x::property_union(ISimpleFillSymbol, NULL, default = NULL)
  )
)

#' WebChartHeatChartSeries
#'
#' The heat chart's series. Cells are shaded by their own `gradientRules` or
#' `classBreaksRules` rather than by the chart's renderer, and the value is
#' the cell count - which is why `set_color()` takes `palette` alone here.
#'
#' @name WebChartHeatChartSeries
#' @return An object of class `WebChartHeatChartSeries`.
#' @examples
#' WebChartHeatChartSeries(
#'   type = "heatSeries",
#'   id = "series0",
#'   x = "species",
#'   y = "island",
#'   heatRulesType = WebChartHeatChartHeatRulesTypes("gradient"),
#'   gradientRules = WebChartHeatChartGradient(
#'     colorList = list(
#'       Color(r = 255, g = 255, b = 255, a = 1),
#'       Color(r = 0, g = 0, b = 128, a = 1)
#'     )
#'   )
#' )
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
    dataTooltipFontSize = s7x::class_float,
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
#'
#' A [WebChart()] with the settings only a heat chart has.
#'
#' @name WebHeatChart
#' @return An object of class `WebHeatChart`.
#' @examples
#' WebHeatChart(
#'   version = "18.1.0",
#'   type = "heatChart",
#'   hideEmptyRowsAndColumns = TRUE,
#'   nullPolicy = WebChartNullPolicyTypes("zero")
#' )
#'
#' # Built for you by the public API.
#' arc_heat(datasets::penguins, species, island)@webchart
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
