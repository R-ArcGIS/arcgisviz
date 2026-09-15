# WebChartTextSymbolHorizontalAlignment

One of `"center"`, `"justify"`, `"left"`, `"right"`, `NA`.

## Usage

``` r
WebChartTextSymbolHorizontalAlignment(value = NA_character_)
```

## Arguments

- value:

  String. One of `"center"`, `"justify"`, `"left"`, `"right"`, `NA`.

## Value

An object of class `WebChartTextSymbolHorizontalAlignment`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
WebChartTextSymbolHorizontalAlignment("center")
#> <arcgisviz::WebChartTextSymbolHorizontalAlignment>
#>  @ value   : chr "center"
#>  @ variants: chr [1:4] "center" "justify" "left" "right"
#>  @ allow_na: logi TRUE
```
