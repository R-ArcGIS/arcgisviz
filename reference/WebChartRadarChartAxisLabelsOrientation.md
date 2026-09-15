# WebChartRadarChartAxisLabelsOrientation

One of `"radial"`, `"circular"`, `"horizontal"`, `NA`.

## Usage

``` r
WebChartRadarChartAxisLabelsOrientation(value = NA_character_)
```

## Arguments

- value:

  String. One of `"radial"`, `"circular"`, `"horizontal"`, `NA`.

## Value

An object of class `WebChartRadarChartAxisLabelsOrientation`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
WebChartRadarChartAxisLabelsOrientation("radial")
#> <arcgisviz::WebChartRadarChartAxisLabelsOrientation>
#>  @ value   : chr "radial"
#>  @ variants: chr [1:3] "radial" "circular" "horizontal"
#>  @ allow_na: logi TRUE
```
