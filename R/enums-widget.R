#' @include arc-data.R
NULL

# Enum for the chart_type argument of arcgis_chart(). Unlike the enums in
# enums-web-chart.R/enums-intl-date-time.R/enums-others.R, this one isn't
# from @arcgis/charts-spec's JSON Schema - it's @arcgis/charts-components'
# own ModelTypes const (model/interfaces/common.d.ts), the set of chart
# types createModel() accepts. Deliberately named to match that export
# exactly for traceability.

#' ModelTypes
#'
#' The `@arcgis/charts-components` chart-type strings accepted by
#' `createModel()`, e.g. `"barChart"`, `"lineChart"`, `"scatterplot"`.
#'
#' @name ModelTypes
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

#' Basemaps
#'
#' The basemap ids `<arcgis-map>` accepts, from `@arcgis/core`'s own
#' `basemapDefinitions.js`. The `-3d` variants are built for scenes.
#'
#' @name Basemaps
#' @export
Basemaps <- s7x::new_enum(
  "Basemaps",
  c(
    "topo-vector",
    "streets-vector",
    "streets-night-vector",
    "streets-relief-vector",
    "streets-navigation-vector",
    "gray-vector",
    "dark-gray-vector",
    "hybrid",
    "satellite",
    "oceans",
    "osm",
    "terrain",
    "topo-3d",
    "streets-3d",
    "streets-dark-3d",
    "navigation-3d",
    "navigation-dark-3d",
    "gray-3d",
    "dark-gray-3d",
    "osm-3d"
  )
)
