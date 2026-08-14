# S7 classes for statistics-definition spec types used by
# WebChartSeriesQuery. Generated from data-raw/spec-type-registry.json.

library(S7)

#' @export
IStatisticDefinitionStatisticParameters := new_class(
  properties = list(
    value = s7x::class_double,
    orderBy = IStatisticDefinitionStatisticParametersOrderBy
  )
)

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
