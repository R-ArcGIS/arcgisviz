# ILegendOptionsOrder

One of `"ascendingValues"`, `"descendingValues"`, `NA`.

## Usage

``` r
ILegendOptionsOrder(value = NA_character_)
```

## Arguments

- value:

  String. One of `"ascendingValues"`, `"descendingValues"`, `NA`.

## Value

An object of class `ILegendOptionsOrder`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
ILegendOptionsOrder("ascendingValues")
#> <arcgisviz::ILegendOptionsOrder>
#>  @ value   : chr "ascendingValues"
#>  @ variants: chr [1:2] "ascendingValues" "descendingValues"
#>  @ allow_na: logi TRUE
```
