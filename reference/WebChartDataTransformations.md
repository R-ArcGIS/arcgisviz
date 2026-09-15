# WebChartDataTransformations

One of `"none"`, `"logarithmic"`, `"squareRoot"`, `NA`.

## Usage

``` r
WebChartDataTransformations(value = NA_character_)
```

## Arguments

- value:

  String. One of `"none"`, `"logarithmic"`, `"squareRoot"`, `NA`.

## Value

An object of class `WebChartDataTransformations`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
WebChartDataTransformations("none")
#> <arcgisviz::WebChartDataTransformations>
#>  @ value   : chr "none"
#>  @ variants: chr [1:3] "none" "logarithmic" "squareRoot"
#>  @ allow_na: logi TRUE
```
