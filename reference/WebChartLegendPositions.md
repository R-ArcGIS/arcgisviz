# WebChartLegendPositions

One of `"bottom"`, `"left"`, `"right"`, `"top"`, `NA`.

## Usage

``` r
WebChartLegendPositions(value = NA_character_)
```

## Arguments

- value:

  String. One of `"bottom"`, `"left"`, `"right"`, `"top"`, `NA`.

## Value

An object of class `WebChartLegendPositions`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
WebChartLegendPositions("bottom")
#> <arcgisviz::WebChartLegendPositions>
#>  @ value   : chr "bottom"
#>  @ variants: chr [1:4] "bottom" "left" "right" "top"
#>  @ allow_na: logi TRUE
```
