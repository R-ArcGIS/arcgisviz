# WebChartClassBreakTypes

One of `"equal-interval"`, `"quantile"`, `"natural-breaks"`, `"manual"`,
`NA`.

## Usage

``` r
WebChartClassBreakTypes(value = NA_character_)
```

## Arguments

- value:

  String. One of `"equal-interval"`, `"quantile"`, `"natural-breaks"`,
  `"manual"`, `NA`.

## Value

An object of class `WebChartClassBreakTypes`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
WebChartClassBreakTypes("equal-interval")
#> <arcgisviz::WebChartClassBreakTypes>
#>  @ value   : chr "equal-interval"
#>  @ variants: chr [1:4] "equal-interval" "quantile" "natural-breaks" "manual"
#>  @ allow_na: logi TRUE
```
