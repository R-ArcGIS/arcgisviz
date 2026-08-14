# S7 classes shared by more than one chart type's series (bar + line, via
# WebChartTemporalSeries). Source of truth:
# node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts (see
# CLAUDE.md).

library(S7)

#' WebChartNullCategory
#' @name WebChartNullCategory
#' @export
WebChartNullCategory := new_class(
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
#' @name WebChartTemporalBinningOffset
#' @export
WebChartTemporalBinningOffset := new_class(
  properties = list(
    unit = WebChartTemporalBinningUnits,
    size = s7x::class_double
  )
)

# Merges WebChartTemporalBinning + WebChartTemporalBinningBase +
# WebChartTemporalBinningExtras (web-chart.d.ts) into one flat class, same
# allOf-merge treatment the old JSON-Schema-derived classes got.
#' WebChartTemporalBinning
#' @name WebChartTemporalBinning
#' @export
WebChartTemporalBinning := new_class(
  properties = list(
    unit = WebChartTemporalBinningUnits,
    size = s7x::class_double,
    timeAggregationType = WebChartTimeAggregationTypes,
    trimIncompleteTimeInterval = s7x::class_boolean,
    start = s7x::class_double,
    end = s7x::class_double,
    offset = s7x::property_union(
      WebChartTemporalBinningOffset,
      NULL,
      default = NULL
    ),
    outTimeZone = s7x::class_string,
    firstDayOfWeek = s7x::class_double,
    nullPolicy = WebChartNullPolicyTypes
  )
)
