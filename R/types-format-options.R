#' @include types-renderer.R
NULL

# S7 classes for the value-format types used by WebChartAxis/WebChartBarChartSeries.
# Source of truth: node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts
# (see CLAUDE.md). Unchanged from the old charts-spec-derived version -
# these types are structurally identical in the current spec.

library(S7)

#' WebChartDateTimeUnitFormatOptions
#'
#' A different date format per time unit, so an axis that zooms from years to
#' hours relabels itself as it goes.
#'
#' @name WebChartDateTimeUnitFormatOptions
#' @return An object of class `WebChartDateTimeUnitFormatOptions`.
#' @examples
#' WebChartDateTimeUnitFormatOptions(
#'   year = IntlDateTimeFormatOptions(
#'     year = IntlDateTimeDigitStyle("numeric")
#'   ),
#'   month = IntlDateTimeFormatOptions(
#'     month = IntlDateTimeFormatOptionsMonth("short")
#'   )
#' )
#' @export
WebChartDateTimeUnitFormatOptions <- new_class(
  "WebChartDateTimeUnitFormatOptions",
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

#' NumberFormatOptions
#'
#' How a numeric axis or label formats its values.
#'
#' @name NumberFormatOptions
#' @return An object of class `NumberFormatOptions`.
#' @examples
#' NumberFormatOptions(
#'   type = "number",
#'   intlOptions = IntlNumberFormatOptions(
#'     useGrouping = TRUE,
#'     maximumFractionDigits = 0
#'   )
#' )
#' @export
NumberFormatOptions <- new_class(
  "NumberFormatOptions",
  properties = list(
    type = s7x::class_string,
    intlOptions = IntlNumberFormatOptions
  )
)

#' DateTimeFormatOptions
#'
#' How a date axis or label formats its values.
#'
#' @name DateTimeFormatOptions
#' @return An object of class `DateTimeFormatOptions`.
#' @examples
#' DateTimeFormatOptions(
#'   type = "date-time",
#'   intlOptions = IntlDateTimeFormatOptions(
#'     year = IntlDateTimeDigitStyle("numeric"),
#'     month = IntlDateTimeFormatOptionsMonth("short")
#'   )
#' )
#' @export
DateTimeFormatOptions <- new_class(
  "DateTimeFormatOptions",
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
