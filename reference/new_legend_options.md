# Describe a renderer in the legend

Names and orders what a renderer or a colour ramp contributes to the
map's legend. Pass the result as the `legendOptions` of
[`new_renderer()`](http://r.esri.com/arcgisviz/reference/new_renderer.md)
or of a colour visual variable.

## Usage

``` r
new_legend_options(title = NULL, visible = NULL, order = NULL)
```

## Arguments

- title:

  default `NULL`. Defines the text naming this renderer or ramp.

- visible:

  default `NULL`. Defines whether it appears in the legend at all. Has
  no effect under a `"unique-value"` renderer, which the spec does not
  allow it on.

- order:

  default `NULL`. Defines which end comes first, either `"ascending"` or
  `"descending"`.

## Value

An
[ILegendOptions](http://r.esri.com/arcgisviz/reference/ILegendOptions.md).

## Details

A continuous ramp is otherwise unlabelled, so `title` is the usual
reason to reach for this.

## Examples

``` r
new_legend_options(title = "Births, 1974", order = "descending")
#> <arcgisviz::ILegendOptions>
#>  @ title     : chr "Births, 1974"
#>  @ showLegend: logi NA
#>  @ order     : <arcgisviz::ILegendOptionsOrder>
#>  .. @ value   : chr "descendingValues"
#>  .. @ variants: chr [1:2] "ascendingValues" "descendingValues"
#>  .. @ allow_na: logi TRUE
```
