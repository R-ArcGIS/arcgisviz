# WebChartDirectionalDataOrderOrderType

One of `"arcgis-charts-category"`, `"arcgis-charts-mean"`,
`"arcgis-charts-median"`, `"arcgis-charts-y-value"`, `NA`.

## Usage

``` r
WebChartDirectionalDataOrderOrderType(value = NA_character_)
```

## Arguments

- value:

  String. One of `"arcgis-charts-category"`, `"arcgis-charts-mean"`,
  `"arcgis-charts-median"`, `"arcgis-charts-y-value"`, `NA`.

## Value

An object of class `WebChartDirectionalDataOrderOrderType`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
WebChartDirectionalDataOrderOrderType("arcgis-charts-category")
#> <arcgisviz::WebChartDirectionalDataOrderOrderType>
#>  @ value   : chr "arcgis-charts-category"
#>  @ variants: chr [1:4] "arcgis-charts-category" "arcgis-charts-mean" ...
#>  @ allow_na: logi TRUE
```
