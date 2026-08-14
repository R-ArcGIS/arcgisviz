# Enums for ArcGIS Charts WebChart* spec types. Generated from
# data-raw/enums.json (see data-raw/resolve-spec-types.R and
# data-raw/extract-enums.R for provenance). Coincidentally-identical
# variant sets that shared no named type in the spec were merged into one
# enum; see the commit/PR notes for which originals were folded together.

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

#' @export
WebChartTimeIntervalUnits <- s7x::new_enum(
  "WebChartTimeIntervalUnits",
  c(
    "esriTimeUnitsDays",
    "esriTimeUnitsHours",
    "esriTimeUnitsMinutes",
    "esriTimeUnitsMonths",
    "esriTimeUnitsSeconds",
    "esriTimeUnitsWeeks",
    "esriTimeUnitsYears"
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
WebChartOrderDataByTypes <- s7x::new_enum(
  "WebChartOrderDataByTypes",
  c(
    "arcgis-charts-category",
    "arcgis-charts-mean",
    "arcgis-charts-median",
    "arcgis-charts-y-value"
  )
)

#' @export
WebChartSortOrderKinds <- s7x::new_enum(
  "WebChartSortOrderKinds",
  c("ASC", "DESC")
)

# Merged: WebChart.horizontalAxisLabelsBehavior + WebChart.verticalAxisLabelsBehavior
# (identical 4-value variant set at the type level, per the JSON schema;
# the two properties differ in which subset is practically meaningful,
# but that's a business-rule constraint, not a type-level one)
#' @export
WebChartAxisLabelsBehavior <- s7x::new_enum(
  "WebChartAxisLabelsBehavior",
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

#' @export
WebChartDataFiltersUnits <- s7x::new_enum(
  "WebChartDataFiltersUnits",
  c(
    "feet",
    "kilometers",
    "meters",
    "miles",
    "nautical-miles",
    "us-nautical-miles"
  )
)
