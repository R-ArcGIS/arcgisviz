# WebChartSeriesQuery

The query a series runs against its layer. Its *shape* is what decides
the chart subtype client-side: no `outStatistics` plots values as they
are, and `groupByFieldsForStatistics` alongside them aggregates.

## Usage

``` r
WebChartSeriesQuery(
  outFields = character(0),
  where = NA_character_,
  groupByFieldsForStatistics = character(0),
  outStatistics = list(),
  returnDistinctValues = NA,
  fetchNullValues = NA
)
```

## Arguments

- outFields:

  String.

- where:

  String.

- groupByFieldsForStatistics:

  String.

- outStatistics:

  List.

- returnDistinctValues:

  Bool.

- fetchNullValues:

  Bool.

## Value

An object of class `WebChartSeriesQuery`.

## Examples

``` r
# Aggregating: mean body mass per species.
WebChartSeriesQuery(
  groupByFieldsForStatistics = "species",
  outStatistics = list(
    IStatisticDefinition(
      statisticType = IStatisticDefinitionStatisticType("avg"),
      onStatisticField = "body_mass",
      outStatisticFieldName = "AVG_body_mass_0"
    )
  )
)
#> <arcgisviz::WebChartSeriesQuery>
#>  @ outFields                 : chr(0) 
#>  @ where                     : chr NA
#>  @ groupByFieldsForStatistics: chr "species"
#>  @ outStatistics             :List of 1
#>  .. $ : <arcgisviz::IStatisticDefinition>
#>  ..  ..@ statisticType        : <arcgisviz::IStatisticDefinitionStatisticType>
#>  .. .. .. @ value   : chr "avg"
#>  .. .. .. @ variants: chr [1:12] "avg" "centroid-aggregate" "convex-hull-aggregate" "count" ...
#>  .. .. .. @ allow_na: logi TRUE
#>  ..  ..@ statisticParameters  : NULL
#>  ..  ..@ onStatisticField     : chr "body_mass"
#>  ..  ..@ outStatisticFieldName: chr "AVG_body_mass_0"
#>  @ returnDistinctValues      : logi NA
#>  @ fetchNullValues           : logi NA

# Not aggregating: one mark per row, filtered.
WebChartSeriesQuery(where = "island = 'Biscoe'")
#> <arcgisviz::WebChartSeriesQuery>
#>  @ outFields                 : chr(0) 
#>  @ where                     : chr "island = 'Biscoe'"
#>  @ groupByFieldsForStatistics: chr(0) 
#>  @ outStatistics             : list()
#>  @ returnDistinctValues      : logi NA
#>  @ fetchNullValues           : logi NA
```
