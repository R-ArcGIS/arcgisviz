# RESTUnits

One of `"feet"`, `"kilometers"`, `"meters"`, `"miles"`,
`"nautical-miles"`, `"us-nautical-miles"`, `NA`.

## Usage

``` r
RESTUnits(value = NA_character_)
```

## Arguments

- value:

  String. One of `"feet"`, `"kilometers"`, `"meters"`, `"miles"`,
  `"nautical-miles"`, `"us-nautical-miles"`, `NA`.

## Value

An object of class `RESTUnits`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
RESTUnits("feet")
#> <arcgisviz::RESTUnits>
#>  @ value   : chr "feet"
#>  @ variants: chr [1:6] "feet" "kilometers" "meters" "miles" "nautical-miles" ...
#>  @ allow_na: logi TRUE
```
