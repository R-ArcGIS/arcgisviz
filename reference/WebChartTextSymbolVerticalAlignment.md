# WebChartTextSymbolVerticalAlignment

One of `"baseline"`, `"bottom"`, `"middle"`, `"top"`, `NA`.

## Usage

``` r
WebChartTextSymbolVerticalAlignment(value = NA_character_)
```

## Arguments

- value:

  String. One of `"baseline"`, `"bottom"`, `"middle"`, `"top"`, `NA`.

## Value

An object of class `WebChartTextSymbolVerticalAlignment`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
WebChartTextSymbolVerticalAlignment("baseline")
#> <arcgisviz::WebChartTextSymbolVerticalAlignment>
#>  @ value   : chr "baseline"
#>  @ variants: chr [1:4] "baseline" "bottom" "middle" "top"
#>  @ allow_na: logi TRUE
```
