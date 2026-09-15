# GaugeChartSubTypes

One of `"featureGauge"`, `"statisticGauge"`, `NA`.

## Usage

``` r
GaugeChartSubTypes(value = NA_character_)
```

## Arguments

- value:

  String. One of `"featureGauge"`, `"statisticGauge"`, `NA`.

## Value

An object of class `GaugeChartSubTypes`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
GaugeChartSubTypes("featureGauge")
#> <arcgisviz::GaugeChartSubTypes>
#>  @ value   : chr "featureGauge"
#>  @ variants: chr [1:2] "featureGauge" "statisticGauge"
#>  @ allow_na: logi TRUE
```
