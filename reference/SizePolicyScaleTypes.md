# SizePolicyScaleTypes

One of `"linear"`, `"logarithmic"`, `NA`.

## Usage

``` r
SizePolicyScaleTypes(value = NA_character_)
```

## Arguments

- value:

  String. One of `"linear"`, `"logarithmic"`, `NA`.

## Value

An object of class `SizePolicyScaleTypes`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
SizePolicyScaleTypes("linear")
#> <arcgisviz::SizePolicyScaleTypes>
#>  @ value   : chr "linear"
#>  @ variants: chr [1:2] "linear" "logarithmic"
#>  @ allow_na: logi TRUE
```
