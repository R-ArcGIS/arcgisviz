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
#' @name IStatisticDefinitionStatisticParameters
#' @export
IStatisticDefinitionStatisticParameters := new_class(
  properties = list(
    value = s7x::class_double,
    orderBy = IStatisticDefinitionStatisticParametersOrderBy
  )
)

#' IStatisticDefinition
#' @name IStatisticDefinition
#' @export
IStatisticDefinition := new_class(
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
#' @name WebChartSeriesQuery
#' @export
WebChartSeriesQuery := new_class(
  properties = list(
    outFields = S7::class_character,
    where = s7x::class_string,
    groupByFieldsForStatistics = S7::class_character,
    outStatistics = class_list,
    returnDistinctValues = s7x::class_boolean,
    fetchNullValues = s7x::class_boolean
  )
)
