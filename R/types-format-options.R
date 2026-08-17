#' @include types-renderer.R
NULL

# S7 classes for the value-format types used by WebChartAxis/WebChartBarChartSeries.
# Source of truth: node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts
# (see CLAUDE.md). Unchanged from the old charts-spec-derived version -
# these types are structurally identical in the current spec.

library(S7)

#' WebChartDateTimeUnitFormatOptions
#' @name WebChartDateTimeUnitFormatOptions
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
#' @name NumberFormatOptions
#' @export
NumberFormatOptions <- new_class(
  "NumberFormatOptions",
  properties = list(
    type = s7x::class_string,
    intlOptions = IntlNumberFormatOptions
  )
)

#' DateTimeFormatOptions
#' @name DateTimeFormatOptions
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
