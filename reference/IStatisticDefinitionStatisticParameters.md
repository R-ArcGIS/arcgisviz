# IStatisticDefinitionStatisticParameters

Extra arguments for the statistics that take them - the percentile ones.

## Usage

``` r
IStatisticDefinitionStatisticParameters(
  value = NA_real_,
  orderBy = IStatisticDefinitionStatisticParametersOrderBy()
)
```

## Arguments

- value:

  Number.

- orderBy:

  A `IStatisticDefinitionStatisticParametersOrderBy` enum.

## Value

An object of class `IStatisticDefinitionStatisticParameters`.

## Examples

``` r
IStatisticDefinitionStatisticParameters(
  value = 0.9,
  orderBy = IStatisticDefinitionStatisticParametersOrderBy("asc")
)
#> <arcgisviz::IStatisticDefinitionStatisticParameters>
#>  @ value  : num 0.9
#>  @ orderBy: <arcgisviz::IStatisticDefinitionStatisticParametersOrderBy>
#>  .. @ value   : chr "asc"
#>  .. @ variants: chr [1:2] "asc" "desc"
#>  .. @ allow_na: logi TRUE
```
