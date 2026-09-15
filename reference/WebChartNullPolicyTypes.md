# WebChartNullPolicyTypes

One of `"interpolate"`, `"null"`, `"zero"`, `NA`.

## Usage

``` r
WebChartNullPolicyTypes(value = NA_character_)
```

## Arguments

- value:

  String. One of `"interpolate"`, `"null"`, `"zero"`, `NA`.

## Value

An object of class `WebChartNullPolicyTypes`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
WebChartNullPolicyTypes("interpolate")
#> <arcgisviz::WebChartNullPolicyTypes>
#>  @ value   : chr "interpolate"
#>  @ variants: chr [1:3] "interpolate" "null" "zero"
#>  @ allow_na: logi TRUE
```
