#' @include enums-web-chart.R
NULL

# Enums for the JS-native Intl.DateTimeFormatOptions / Intl.NumberFormatOptions
# types used by ArcGIS Charts' NumberFormatOptions/DateTimeFormatOptions specs.
# Generated from data-raw/enums.json (see data-raw/resolve-spec-types.R and
# data-raw/extract-enums.R for provenance).
#
# NOTE: Intl.DateTimeFormatOptions.fractionalSecondDigits has variants
# [1, 2, 3] (numbers, not strings) and is intentionally NOT modeled here as
# an enum - s7x::Enum values are scalar character. Use
# s7x::property_range_discrete(1L, 3L) for that property instead.

# Merged: Intl.DateTimeFormatOptions.localeMatcher + Intl.NumberFormatOptions.localeMatcher
#' @export
IntlLocaleMatcher <- s7x::new_enum(
  "IntlLocaleMatcher",
  c("best fit", "lookup")
)

# Merged: Intl.DateTimeFormatOptions.{weekday,era,dayPeriod} +
# Intl.NumberFormatOptions.unitDisplay. ECMA-402 refers to this
# long/short/narrow tri-state as a format "width".
#' @export
IntlFormatWidth <- s7x::new_enum(
  "IntlFormatWidth",
  c("long", "narrow", "short")
)

# Merged: Intl.DateTimeFormatOptions.{year,day,hour,minute,second}
#' @export
IntlDateTimeDigitStyle <- s7x::new_enum(
  "IntlDateTimeDigitStyle",
  c("2-digit", "numeric")
)

# Merged: Intl.DateTimeFormatOptions.{dateStyle,timeStyle}
#' @export
IntlDateTimeFormatLength <- s7x::new_enum(
  "IntlDateTimeFormatLength",
  c("full", "long", "medium", "short")
)

#' @export
IntlDateTimeFormatOptionsFormatMatcher <- s7x::new_enum(
  "IntlDateTimeFormatOptionsFormatMatcher",
  c("basic", "best fit")
)

#' @export
IntlDateTimeFormatOptionsTimeZoneName <- s7x::new_enum(
  "IntlDateTimeFormatOptionsTimeZoneName",
  c("long", "longGeneric", "longOffset", "short", "shortGeneric", "shortOffset")
)

#' @export
IntlDateTimeFormatOptionsHourCycle <- s7x::new_enum(
  "IntlDateTimeFormatOptionsHourCycle",
  c("h11", "h12", "h23", "h24")
)

#' @export
IntlDateTimeFormatOptionsMonth <- s7x::new_enum(
  "IntlDateTimeFormatOptionsMonth",
  c("2-digit", "long", "narrow", "numeric", "short")
)

#' @export
IntlNumberFormatOptionsStyle <- s7x::new_enum(
  "IntlNumberFormatOptionsStyle",
  c("currency", "decimal", "percent", "unit")
)

#' @export
IntlNumberFormatOptionsCurrencyDisplay <- s7x::new_enum(
  "IntlNumberFormatOptionsCurrencyDisplay",
  c("code", "name", "narrowSymbol", "symbol")
)

#' @export
IntlNumberFormatOptionsCompactDisplay <- s7x::new_enum(
  "IntlNumberFormatOptionsCompactDisplay",
  c("long", "short")
)

#' @export
IntlNumberFormatOptionsNotation <- s7x::new_enum(
  "IntlNumberFormatOptionsNotation",
  c("compact", "engineering", "scientific", "standard")
)

#' @export
IntlNumberFormatOptionsSignDisplay <- s7x::new_enum(
  "IntlNumberFormatOptionsSignDisplay",
  c("always", "auto", "exceptZero", "never")
)

#' @export
IntlNumberFormatOptionsCurrencySign <- s7x::new_enum(
  "IntlNumberFormatOptionsCurrencySign",
  c("accounting", "standard")
)
