# IntlLocaleMatcher

One of `"best fit"`, `"lookup"`, `NA`.

## Usage

``` r
IntlLocaleMatcher(value = NA_character_)
```

## Arguments

- value:

  String. One of `"best fit"`, `"lookup"`, `NA`.

## Value

An object of class `IntlLocaleMatcher`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
IntlLocaleMatcher("best fit")
#> <arcgisviz::IntlLocaleMatcher>
#>  @ value   : chr "best fit"
#>  @ variants: chr [1:2] "best fit" "lookup"
#>  @ allow_na: logi TRUE
```
