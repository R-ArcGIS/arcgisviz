# S7 classes for the value-format types used by WebChartAxis/WebChartBarChartSeries.
# Generated from data-raw/spec-type-registry.json.

library(S7)

#' @export
WebChartDateTimeUnitFormatOptions := new_class(
  properties = list(
    year = s7x::property_union(IntlDateTimeFormatOptions, NULL, default = NULL),
    month = s7x::property_union(
      IntlDateTimeFormatOptions,
      NULL,
      default = NULL
    ),
    day = s7x::property_union(IntlDateTimeFormatOptions, NULL, default = NULL),
    hour = s7x::property_union(IntlDateTimeFormatOptions, NULL, default = NULL),
    minute = s7x::property_union(
      IntlDateTimeFormatOptions,
      NULL,
      default = NULL
    ),
    second = s7x::property_union(
      IntlDateTimeFormatOptions,
      NULL,
      default = NULL
    )
  )
)

#' @export
NumberFormatOptions := new_class(
  properties = list(
    type = s7x::class_string,
    intlOptions = IntlNumberFormatOptions
  )
)

#' @export
DateTimeFormatOptions := new_class(
  properties = list(
    type = s7x::class_string,
    intlOptions = IntlDateTimeFormatOptions,
    formatPerDateTimeUnit = s7x::property_union(
      WebChartDateTimeUnitFormatOptions,
      NULL,
      default = NULL
    )
  )
)
