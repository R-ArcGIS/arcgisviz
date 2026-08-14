# S7 classes for ArcGIS Charts spec object types whose properties are all
# primitives, Color, or enums - no nested/ref'd object types. Generated
# from data-raw/spec-type-registry.json.
#
# Optional properties (not in the schema's `required` array): scalar/enum
# ones need no special handling - NA already satisfies class_string,
# class_double, class_boolean, and Enum's allow_na. Object-typed optional
# properties (Color, another class) get property_union(Type, NULL,
# default = NULL) since there's no NA equivalent for a class instance.

library(S7)

#' @export
WebChartAxisScrollBar := new_class(
  properties = list(
    visible = s7x::class_boolean,
    width = s7x::class_double,
    color = s7x::property_union(Color, NULL, default = NULL),
    gripSize = s7x::class_double,
    margin = s7x::class_double
  )
)

#' @export
ISimpleLineSymbol := new_class(
  properties = list(
    type = s7x::class_string,
    style = ISimpleLineSymbolStyle,
    color = s7x::property_union(Color, NULL, default = NULL),
    width = s7x::class_double
  )
)

#' @export
CategoryFormatOptions := new_class(
  properties = list(
    type = s7x::class_string,
    characterLimit = s7x::class_double
  )
)

#' @export
WebChartOrderSeriesBy := new_class(
  properties = list(
    preferLabel = s7x::class_boolean,
    orderBy = WebChartSortOrderKinds
  )
)

#' @export
WebChartPredefinedLabelsDataOrder := new_class(
  properties = list(
    orderType = s7x::class_string,
    orderBy = S7::class_character,
    preferLabel = s7x::class_boolean
  )
)

#' @export
IFont := new_class(
  properties = list(
    family = s7x::class_string,
    size = s7x::class_double,
    style = IFontStyle,
    weight = IFontWeight,
    decoration = IFontDecoration
  )
)

#' @export
IntlDateTimeFormatOptions := new_class(
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

#' @export
IntlNumberFormatOptions := new_class(
  properties = list(
    localeMatcher = IntlLocaleMatcher,
    style = IntlNumberFormatOptionsStyle,
    currency = s7x::class_string,
    currencyDisplay = IntlNumberFormatOptionsCurrencyDisplay,
    useGrouping = s7x::class_boolean,
    minimumIntegerDigits = s7x::class_double,
    minimumFractionDigits = s7x::class_double,
    maximumFractionDigits = s7x::class_double,
    minimumSignificantDigits = s7x::class_double,
    maximumSignificantDigits = s7x::class_double,
    numberingSystem = s7x::class_string,
    compactDisplay = IntlNumberFormatOptionsCompactDisplay,
    notation = IntlNumberFormatOptionsNotation,
    signDisplay = IntlNumberFormatOptionsSignDisplay,
    unit = s7x::class_string,
    unitDisplay = IntlFormatWidth,
    currencySign = IntlNumberFormatOptionsCurrencySign
  )
)
