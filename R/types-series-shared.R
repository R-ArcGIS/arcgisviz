#' @include types-webchart.R
NULL

# S7 classes shared by more than one chart type's series (bar + line, via
# WebChartTemporalSeries). Source of truth:
# node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts (see
# CLAUDE.md).

library(S7)

#' WebChartNullCategory
#'
#' How rows with a missing category are labelled and drawn.
#'
#' @name WebChartNullCategory
#' @return An object of class `WebChartNullCategory`.
#' @examples
#' WebChartNullCategory(
#'   text = "Unknown",
#'   symbol = ISimpleFillSymbol(color = Color(r = 200, g = 200, b = 200, a = 1))
#' )
#' @export
WebChartNullCategory <- new_class(
  "WebChartNullCategory",
  properties = list(
    text = s7x::class_string,
    symbol = s7x::property_union(ISimpleFillSymbol, NULL, default = NULL)
  )
)

# WebChartTemporalBinning$offset is an anonymous inline object type in the
# spec (both fields required within it) - hoisted here per the
# ParentType+propertyPath naming convention (see the arcgis-spec-types
# skill).
#' WebChartTemporalBinningOffset
#'
#' Shifts where temporal bins start - a fiscal year beginning in April rather
#' than January, say.
#'
#' @name WebChartTemporalBinningOffset
#' @return An object of class `WebChartTemporalBinningOffset`.
#' @examples
#' WebChartTemporalBinningOffset(
#'   unit = WebChartTemporalBinningUnits("months"),
#'   size = 3
#' )
#' @export
WebChartTemporalBinningOffset <- new_class(
  "WebChartTemporalBinningOffset",
  properties = list(
    unit = WebChartTemporalBinningUnits,
    size = s7x::class_float
  )
)

# Merges WebChartTemporalBinning + WebChartTemporalBinningBase +
# WebChartTemporalBinningExtras (web-chart.d.ts) into one flat class, same
# allOf-merge treatment the old JSON-Schema-derived classes got.
#' WebChartTemporalBinning
#'
#' Groups a date column into intervals before plotting it.
#'
#' @name WebChartTemporalBinning
#' @return An object of class `WebChartTemporalBinning`.
#' @examples
#' WebChartTemporalBinning(
#'   unit = WebChartTemporalBinningUnits("months"),
#'   size = 1,
#'   trimIncompleteTimeInterval = TRUE,
#'   nullPolicy = WebChartNullPolicyTypes("zero")
#' )
#' @export
WebChartTemporalBinning <- new_class(
  "WebChartTemporalBinning",
  properties = list(
    unit = WebChartTemporalBinningUnits,
    size = s7x::class_float,
    timeAggregationType = WebChartTimeAggregationTypes,
    trimIncompleteTimeInterval = s7x::class_boolean,
    start = s7x::class_float,
    end = s7x::class_float,
    offset = s7x::property_union(
      WebChartTemporalBinningOffset,
      NULL,
      default = NULL
    ),
    outTimeZone = s7x::class_string,
    firstDayOfWeek = s7x::class_float,
    nullPolicy = WebChartNullPolicyTypes
  )
)
