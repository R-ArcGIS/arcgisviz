# IStatisticDefinition

One aggregation in a series query: which statistic, on which column, and
what to call the result.
[`set_stat()`](http://r.esri.com/arcgisviz/reference/set_stat.md) builds
these for you, and under aggregation the series' `y` must name the
`outStatisticFieldName`.

## Usage

``` r
IStatisticDefinition(
  statisticType = IStatisticDefinitionStatisticType(),
  statisticParameters = NULL,
  onStatisticField = NA_character_,
  outStatisticFieldName = NA_character_
)
```

## Arguments

- statisticType:

  A `IStatisticDefinitionStatisticType` enum.

- statisticParameters:

  `NULL` or a `IStatisticDefinitionStatisticParameters` object.

- onStatisticField:

  String.

- outStatisticFieldName:

  String.

## Value

An object of class `IStatisticDefinition`.

## Examples

``` r
IStatisticDefinition(
  statisticType = IStatisticDefinitionStatisticType("avg"),
  onStatisticField = "body_mass",
  outStatisticFieldName = "AVG_body_mass_0"
)
#> <arcgisviz::IStatisticDefinition>
#>  @ statisticType        : <arcgisviz::IStatisticDefinitionStatisticType>
#>  .. @ value   : chr "avg"
#>  .. @ variants: chr [1:12] "avg" "centroid-aggregate" "convex-hull-aggregate" ...
#>  .. @ allow_na: logi TRUE
#>  @ statisticParameters  : NULL
#>  @ onStatisticField     : chr "body_mass"
#>  @ outStatisticFieldName: chr "AVG_body_mass_0"
```
