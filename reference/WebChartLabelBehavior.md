# WebChartLabelBehavior

One of `"hide"`, `"rotate"`, `"stagger"`, `"wrap"`, `NA`.

## Usage

``` r
WebChartLabelBehavior(value = NA_character_)
```

## Arguments

- value:

  String. One of `"hide"`, `"rotate"`, `"stagger"`, `"wrap"`, `NA`.

## Value

An object of class `WebChartLabelBehavior`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
WebChartLabelBehavior("hide")
#> <arcgisviz::WebChartLabelBehavior>
#>  @ value   : chr "hide"
#>  @ variants: chr [1:4] "hide" "rotate" "stagger" "wrap"
#>  @ allow_na: logi TRUE
```
