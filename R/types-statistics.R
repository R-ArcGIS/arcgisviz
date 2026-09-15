#' @include types-format-options.R
NULL

# S7 classes for statistics-definition spec types used by
# WebChartSeriesQuery. Source of truth:
# node_modules/@arcgis/charts-components/dist/spec/rest-js-types.d.ts
# (IStatisticDefinition, its inline statisticParameters object type) and
# .../dist/spec/web-chart.d.ts (WebChartQuery, Omit'd into
# WebChartSeriesQuery). See CLAUDE.md. Structurally unchanged from the old
# charts-spec-derived version except IStatisticDefinitionStatisticType's
# variant spelling - see R/enums-others.R.

library(S7)

#' IStatisticDefinitionStatisticParameters
#'
#' Extra arguments for the statistics that take them - the percentile ones.
#'
#' @name IStatisticDefinitionStatisticParameters
#' @return An object of class `IStatisticDefinitionStatisticParameters`.
#' @examples
#' IStatisticDefinitionStatisticParameters(
#'   value = 0.9,
#'   orderBy = IStatisticDefinitionStatisticParametersOrderBy("asc")
#' )
#' @export
IStatisticDefinitionStatisticParameters <- new_class(
  "IStatisticDefinitionStatisticParameters",
  properties = list(
    value = s7x::class_float,
    orderBy = IStatisticDefinitionStatisticParametersOrderBy
  )
)

#' IStatisticDefinition
#'
#' One aggregation in a series query: which statistic, on which column, and
#' what to call the result. [set_stat()] builds these for you, and under
#' aggregation the series' `y` must name the `outStatisticFieldName`.
#'
#' @name IStatisticDefinition
#' @return An object of class `IStatisticDefinition`.
#' @examples
#' IStatisticDefinition(
#'   statisticType = IStatisticDefinitionStatisticType("avg"),
#'   onStatisticField = "body_mass",
#'   outStatisticFieldName = "AVG_body_mass_0"
#' )
#' @export
IStatisticDefinition <- new_class(
  "IStatisticDefinition",
  properties = list(
    statisticType = IStatisticDefinitionStatisticType,
    statisticParameters = s7x::property_union(
      IStatisticDefinitionStatisticParameters,
      NULL,
      default = NULL
    ),
    onStatisticField = s7x::class_string,
    outStatisticFieldName = s7x::class_string
  )
)

#' WebChartSeriesQuery
#'
#' The query a series runs against its layer. Its *shape* is what decides the
#' chart subtype client-side: no `outStatistics` plots values as they are, and
#' `groupByFieldsForStatistics` alongside them aggregates.
#'
#' @name WebChartSeriesQuery
#' @return An object of class `WebChartSeriesQuery`.
#' @examples
#' # Aggregating: mean body mass per species.
#' WebChartSeriesQuery(
#'   groupByFieldsForStatistics = "species",
#'   outStatistics = list(
#'     IStatisticDefinition(
#'       statisticType = IStatisticDefinitionStatisticType("avg"),
#'       onStatisticField = "body_mass",
#'       outStatisticFieldName = "AVG_body_mass_0"
#'     )
#'   )
#' )
#'
#' # Not aggregating: one mark per row, filtered.
#' WebChartSeriesQuery(where = "island = 'Biscoe'")
#' @export
WebChartSeriesQuery <- new_class(
  "WebChartSeriesQuery",
  properties = list(
    outFields = S7::class_character,
    where = s7x::class_string,
    groupByFieldsForStatistics = S7::class_character,
    outStatistics = class_list,
    returnDistinctValues = s7x::class_boolean,
    fetchNullValues = s7x::class_boolean
  )
)
