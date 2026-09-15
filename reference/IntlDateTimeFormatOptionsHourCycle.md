# IntlDateTimeFormatOptionsHourCycle

One of `"h11"`, `"h12"`, `"h23"`, `"h24"`, `NA`.

## Usage

``` r
IntlDateTimeFormatOptionsHourCycle(value = NA_character_)
```

## Arguments

- value:

  String. One of `"h11"`, `"h12"`, `"h23"`, `"h24"`, `NA`.

## Value

An object of class `IntlDateTimeFormatOptionsHourCycle`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
IntlDateTimeFormatOptionsHourCycle("h11")
#> <arcgisviz::IntlDateTimeFormatOptionsHourCycle>
#>  @ value   : chr "h11"
#>  @ variants: chr [1:4] "h11" "h12" "h23" "h24"
#>  @ allow_na: logi TRUE
```
