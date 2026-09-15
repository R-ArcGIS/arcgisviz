# ILegendOptions

How a renderer or visual variable describes itself in a legend. Note
`showLegend` is unavailable under `IUniqueValueRenderer`, per the spec.

## Value

An object of class `ILegendOptions`.

## See also

[`new_legend_options()`](http://r.esri.com/arcgisviz/reference/new_legend_options.md),
which builds one from friendly names.

## Examples

``` r
ILegendOptions(
  title = "Body mass (g)",
  showLegend = TRUE,
  order = ILegendOptionsOrder("descendingValues")
)
#> <arcgisviz::ILegendOptions>
#>  @ title     : chr "Body mass (g)"
#>  @ showLegend: logi TRUE
#>  @ order     : <arcgisviz::ILegendOptionsOrder>
#>  .. @ value   : chr "descendingValues"
#>  .. @ variants: chr [1:2] "ascendingValues" "descendingValues"
#>  .. @ allow_na: logi TRUE
```
