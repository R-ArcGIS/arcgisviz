# IRendererRotationType

One of `"arithmetic"`, `"geographic"`, `NA`.

## Usage

``` r
IRendererRotationType(value = NA_character_)
```

## Arguments

- value:

  String. One of `"arithmetic"`, `"geographic"`, `NA`.

## Value

An object of class `IRendererRotationType`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
IRendererRotationType("arithmetic")
#> <arcgisviz::IRendererRotationType>
#>  @ value   : chr "arithmetic"
#>  @ variants: chr [1:2] "arithmetic" "geographic"
#>  @ allow_na: logi TRUE
```
