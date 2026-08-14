# Enum for the chart_type argument of arcgis_chart(). Unlike the enums in
# enums-web-chart.R/enums-intl-date-time.R/enums-others.R, this one isn't
# from @arcgis/charts-spec's JSON Schema - it's @arcgis/charts-components'
# own ModelTypes const (model/interfaces/common.d.ts), the set of chart
# types createModel() accepts. Deliberately named to match that export
# exactly for traceability.

#' @export
ModelTypes <- s7x::new_enum(
  "ModelTypes",
  c(
    "barChart",
    "lineChart",
    "comboBarLineChart",
    "boxPlot",
    "pieChart",
    "scatterplot",
    "histogram",
    "gauge",
    "radarChart",
    "heatChart"
  )
)
