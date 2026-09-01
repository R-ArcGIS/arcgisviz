#' @include color.R
NULL

# Enums for ArcGIS Charts WebChart* config types. Source of truth is the
# spec bundled inside @arcgis/charts-components (not the standalone, stale
# @arcgis/charts-model/@arcgis/charts-spec packages - see CLAUDE.md):
# node_modules/@arcgis/charts-components/dist/spec/chart-object-literals.d.ts
# and .../dist/spec/web-chart.d.ts (for inline literal-union properties with
# no named export - those get a ParentType+propertyPath name here).

#' @export
WebChartStackedKinds <- s7x::new_enum(
  "WebChartStackedKinds",
  c("sideBySide", "stacked", "stacked100")
)

#' @export
WebChartLegendPositions <- s7x::new_enum(
  "WebChartLegendPositions",
  c("bottom", "left", "right", "top")
)

# Renamed from the old WebChartTimeIntervalUnits ("esriTimeUnitsDays" etc) -
# the current spec uses plain unit words instead, and nests this inside
# WebChartTemporalBinning$unit rather than flat series properties.
#' @export
WebChartTemporalBinningUnits <- s7x::new_enum(
  "WebChartTemporalBinningUnits",
  c(
    "days",
    "hours",
    "minutes",
    "months",
    "quarters",
    "seconds",
    "weeks",
    "years"
  )
)

#' @export
WebChartTimeAggregationTypes <- s7x::new_enum(
  "WebChartTimeAggregationTypes",
  c("equalIntervalsFromEndTime", "equalIntervalsFromStartTime")
)

#' @export
WebChartNullPolicyTypes <- s7x::new_enum(
  "WebChartNullPolicyTypes",
  c("interpolate", "null", "zero")
)

#' @export
WebChartSortOrderKinds <- s7x::new_enum(
  "WebChartSortOrderKinds",
  c("ASC", "DESC")
)

# Renamed from the old WebChartAxisLabelsBehavior - same 4 values, current
# spec calls the exported const WebChartLabelBehavior.
#' @export
WebChartLabelBehavior <- s7x::new_enum(
  "WebChartLabelBehavior",
  c("hide", "rotate", "stagger", "wrap")
)

#' @export
WebChartTextSymbolVerticalAlignment <- s7x::new_enum(
  "WebChartTextSymbolVerticalAlignment",
  c("baseline", "bottom", "middle", "top")
)

#' @export
WebChartTextSymbolHorizontalAlignment <- s7x::new_enum(
  "WebChartTextSymbolHorizontalAlignment",
  c("center", "justify", "left", "right")
)

# WebChartDirectionalDataOrder.orderType is an inline 4-value literal union
# in web-chart.d.ts (not the same as the unused, unreferenced
# WebChartOrderDataByTypes 5-value exported const - that one is dead code
# from our end, nothing in WebChart actually has that type).
#' @export
WebChartDirectionalDataOrderOrderType <- s7x::new_enum(
  "WebChartDirectionalDataOrderOrderType",
  c(
    "arcgis-charts-category",
    "arcgis-charts-mean",
    "arcgis-charts-median",
    "arcgis-charts-y-value"
  )
)

# WebChartQuery.spatialRelationship is an inline literal union, needed for
# WebChartDataFilters (Pick<WebChartQuery, ... "spatialRelationship" ...>).
#' @export
WebChartQuerySpatialRelationship <- s7x::new_enum(
  "WebChartQuerySpatialRelationship",
  c(
    "contains",
    "crosses",
    "disjoint",
    "envelope-intersects",
    "index-intersects",
    "intersects",
    "overlaps",
    "relation",
    "touches",
    "within"
  )
)

#' @export
WebChartDataTransformations <- s7x::new_enum(
  "WebChartDataTransformations",
  c("none", "logarithmic", "squareRoot")
)

#' @export
WebChartClassBreakTypes <- s7x::new_enum(
  "WebChartClassBreakTypes",
  c("equal-interval", "quantile", "natural-breaks", "manual")
)

#' @export
WebChartHeatChartHeatRulesTypes <- s7x::new_enum(
  "WebChartHeatChartHeatRulesTypes",
  c("gradient", "renderer")
)

#' @export
WebChartHeatChartViewTypes <- s7x::new_enum(
  "WebChartHeatChartViewTypes",
  c("SingleCalendarView", "SequentialCalendarViews")
)

#' @export
WebChartCalendarDatePartsUnits <- s7x::new_enum(
  "WebChartCalendarDatePartsUnits",
  c(
    "dayOfMonth",
    "dayOfWeek",
    "dayOfYear",
    "hourOfDay",
    "monthOfYear",
    "minuteOfDay",
    "weekOfYear",
    "quarterOfYear"
  )
)

#' @export
WebChartRadarChartAxisLabelsOrientation <- s7x::new_enum(
  "WebChartRadarChartAxisLabelsOrientation",
  c("radial", "circular", "horizontal")
)
