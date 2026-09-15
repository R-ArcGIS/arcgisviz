#' @include enums-others.R
NULL

# S7 classes for ArcGIS Charts spec object types whose properties are all
# primitives, Color, or enums - no nested/ref'd object types. Source of
# truth: node_modules/@arcgis/charts-components/dist/spec/rest-js-types.d.ts,
# .../dist/spec/web-chart.d.ts, .../dist/spec/chart-object-literals.d.ts
# (see CLAUDE.md - the standalone @arcgis/charts-model/@arcgis/charts-spec
# packages this used to be generated from are stale and removed).
#
# Optional properties (not in the schema's `required` array): scalar/enum
# ones need no special handling - NA already satisfies class_string,
# class_float, class_boolean, and Enum's allow_na. Object-typed optional
# properties (Color, another class) get property_union(Type, NULL,
# default = NULL) since there's no NA equivalent for a class instance.

library(S7)

#' WebChartAxisScrollBar
#' @name WebChartAxisScrollBar
#' @return An object of class `WebChartAxisScrollBar`.
#' @examples
#' WebChartAxisScrollBar(visible = TRUE, width = 12, gripSize = 6)
#' @export
WebChartAxisScrollBar <- new_class(
  "WebChartAxisScrollBar",
  properties = list(
    visible = s7x::class_boolean,
    width = s7x::class_float,
    color = s7x::property_union(Color, NULL, default = NULL),
    gripSize = s7x::class_float,
    margin = s7x::class_float
  )
)

#' ISimpleLineSymbol
#'
#' @name ISimpleLineSymbol
#' @return An object of class `ISimpleLineSymbol`.
#' @seealso [new_symbol()], which builds one from friendly names and colours.
#' @examples
#' ISimpleLineSymbol(
#'   style = SimpleLineSymbolStyle("esriSLSDash"),
#'   color = Color(r = 51, g = 51, b = 51, a = 1),
#'   width = 1.5
#' )
#' @export
ISimpleLineSymbol <- new_class(
  "ISimpleLineSymbol",
  properties = list(
    type = s7x::property_scalar(class_character, default = "esriSLS"),
    style = SimpleLineSymbolStyle,
    color = s7x::property_union(Color, NULL, default = NULL),
    width = s7x::class_float
  )
)

#' ISimpleFillSymbol
#'
#' @name ISimpleFillSymbol
#' @return An object of class `ISimpleFillSymbol`.
#' @seealso [new_symbol()], which builds one from friendly names and colours.
#' @examples
#' ISimpleFillSymbol(
#'   color = Color(r = 184, g = 40, b = 40, a = 1),
#'   outline = ISimpleLineSymbol(
#'     color = Color(r = 255, g = 255, b = 255, a = 1),
#'     width = 0.5
#'   )
#' )
#' @export
ISimpleFillSymbol <- new_class(
  "ISimpleFillSymbol",
  properties = list(
    type = s7x::property_scalar(class_character, default = "esriSFS"),
    style = SimpleFillSymbolStyle,
    color = s7x::property_union(Color, NULL, default = NULL),
    outline = s7x::property_union(ISimpleLineSymbol, NULL, default = NULL)
  )
)

#' ISimpleMarkerSymbol
#'
#' @name ISimpleMarkerSymbol
#' @return An object of class `ISimpleMarkerSymbol`.
#' @seealso [new_symbol()], which builds one from friendly names and colours.
#' @examples
#' ISimpleMarkerSymbol(
#'   style = SimpleMarkerSymbolStyle("esriSMSCircle"),
#'   color = Color(r = 70, g = 130, b = 180, a = 1),
#'   size = 8
#' )
#' @export
ISimpleMarkerSymbol <- new_class(
  "ISimpleMarkerSymbol",
  properties = list(
    type = s7x::property_scalar(class_character, default = "esriSMS"),
    style = SimpleMarkerSymbolStyle,
    color = s7x::property_union(Color, NULL, default = NULL),
    size = s7x::class_float,
    outline = s7x::property_union(ISimpleLineSymbol, NULL, default = NULL),
    angle = s7x::class_float,
    xoffset = s7x::class_float,
    yoffset = s7x::class_float
  )
)

#' CategoryFormatOptions
#'
#' @name CategoryFormatOptions
#' @return An object of class `CategoryFormatOptions`.
#' @examples
#' CategoryFormatOptions(type = "category", characterLimit = 20)
#' @export
CategoryFormatOptions <- new_class(
  "CategoryFormatOptions",
  properties = list(
    type = s7x::class_string,
    characterLimit = s7x::class_float
  )
)

#' WebChartOrderSeriesBy
#'
#' @name WebChartOrderSeriesBy
#' @return An object of class `WebChartOrderSeriesBy`.
#' @examples
#' WebChartOrderSeriesBy(
#'   preferLabel = TRUE,
#'   orderBy = WebChartSortOrderKinds("DESC")
#' )
#' @export
WebChartOrderSeriesBy <- new_class(
  "WebChartOrderSeriesBy",
  properties = list(
    preferLabel = s7x::class_boolean,
    orderBy = WebChartSortOrderKinds
  )
)

#' WebChartPredefinedLabelsDataOrder
#'
#' @name WebChartPredefinedLabelsDataOrder
#' @return An object of class `WebChartPredefinedLabelsDataOrder`.
#' @examples
#' WebChartPredefinedLabelsDataOrder(
#'   orderType = "arcgis-charts-predefined-labels",
#'   orderBy = c("Adelie", "Chinstrap", "Gentoo")
#' )
#' @export
WebChartPredefinedLabelsDataOrder <- new_class(
  "WebChartPredefinedLabelsDataOrder",
  properties = list(
    orderType = s7x::class_string,
    orderBy = S7::class_character,
    preferLabel = s7x::class_boolean
  )
)

#' TimeIntervalInfo
#'
#' @name TimeIntervalInfo
#' @return An object of class `TimeIntervalInfo`.
#' @examples
#' TimeIntervalInfo(unit = WebChartTemporalBinningUnits("months"), size = 3)
#' @export
TimeIntervalInfo <- new_class(
  "TimeIntervalInfo",
  properties = list(
    unit = WebChartTemporalBinningUnits,
    size = s7x::class_float
  )
)

#' IFont
#'
#' @name IFont
#' @return An object of class `IFont`.
#' @examples
#' IFont(
#'   family = "Avenir Next",
#'   size = 12,
#'   style = IFontStyle("normal"),
#'   weight = IFontWeight("bold")
#' )
#' @export
IFont <- new_class(
  "IFont",
  properties = list(
    family = s7x::class_string,
    size = s7x::class_float,
    style = IFontStyle,
    weight = IFontWeight,
    decoration = IFontDecoration
  )
)

#' IntlDateTimeFormatOptions
#'
#' Mirrors JavaScript's own `Intl.DateTimeFormat` options object.
#'
#' @name IntlDateTimeFormatOptions
#' @return An object of class `IntlDateTimeFormatOptions`.
#' @examples
#' IntlDateTimeFormatOptions(
#'   year = IntlDateTimeDigitStyle("numeric"),
#'   month = IntlDateTimeFormatOptionsMonth("short"),
#'   day = IntlDateTimeDigitStyle("2-digit")
#' )
#' @export
IntlDateTimeFormatOptions <- new_class(
  "IntlDateTimeFormatOptions",
  properties = list(
    localeMatcher = IntlLocaleMatcher,
    weekday = IntlFormatWidth,
    era = IntlFormatWidth,
    year = IntlDateTimeDigitStyle,
    month = IntlDateTimeFormatOptionsMonth,
    day = IntlDateTimeDigitStyle,
    hour = IntlDateTimeDigitStyle,
    minute = IntlDateTimeDigitStyle,
    second = IntlDateTimeDigitStyle,
    timeZoneName = IntlDateTimeFormatOptionsTimeZoneName,
    formatMatcher = IntlDateTimeFormatOptionsFormatMatcher,
    hour12 = s7x::class_boolean,
    timeZone = s7x::class_string,
    calendar = s7x::class_string,
    dayPeriod = IntlFormatWidth,
    numberingSystem = s7x::class_string,
    dateStyle = IntlDateTimeFormatLength,
    timeStyle = IntlDateTimeFormatLength,
    hourCycle = IntlDateTimeFormatOptionsHourCycle,
    fractionalSecondDigits = s7x::property_range_discrete(1L, 3L)
  )
)

#' IntlNumberFormatOptions
#'
#' Mirrors JavaScript's own `Intl.NumberFormat` options object.
#'
#' @name IntlNumberFormatOptions
#' @return An object of class `IntlNumberFormatOptions`.
#' @examples
#' IntlNumberFormatOptions(
#'   style = IntlNumberFormatOptionsStyle("decimal"),
#'   useGrouping = TRUE,
#'   maximumFractionDigits = 1
#' )
#' @export
IntlNumberFormatOptions <- new_class(
  "IntlNumberFormatOptions",
  properties = list(
    localeMatcher = IntlLocaleMatcher,
    style = IntlNumberFormatOptionsStyle,
    currency = s7x::class_string,
    currencyDisplay = IntlNumberFormatOptionsCurrencyDisplay,
    useGrouping = s7x::class_boolean,
    minimumIntegerDigits = s7x::class_float,
    minimumFractionDigits = s7x::class_float,
    maximumFractionDigits = s7x::class_float,
    minimumSignificantDigits = s7x::class_float,
    maximumSignificantDigits = s7x::class_float,
    numberingSystem = s7x::class_string,
    compactDisplay = IntlNumberFormatOptionsCompactDisplay,
    notation = IntlNumberFormatOptionsNotation,
    signDisplay = IntlNumberFormatOptionsSignDisplay,
    unit = s7x::class_string,
    unitDisplay = IntlFormatWidth,
    currencySign = IntlNumberFormatOptionsCurrencySign
  )
)
