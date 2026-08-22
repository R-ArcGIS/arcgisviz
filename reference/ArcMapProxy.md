# Update a rendered map from the Shiny server

`arc_map_proxy()` wraps a map that is already on screen.
[`set_basemap()`](http://r.esri.com/arcgisviz/reference/set_basemap.md),
[`set_view()`](http://r.esri.com/arcgisviz/reference/set_view.md) and
[`add_layer()`](http://r.esri.com/arcgisviz/reference/add_layer.md) all
work on the result, and
[`arc_update()`](http://r.esri.com/arcgisviz/reference/arc_update.md)
sends the accumulated changes to the browser as one message.

## Usage

``` r
ArcMapProxy(
  layers = list(),
  basemap = NA_character_,
  center = integer(0),
  zoom = NA_real_,
  extent = list(),
  output_id = NA_character_,
  session = NULL
)

arc_map_proxy(output_id, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- output_id:

  Defines which
  [`arcgisMapOutput()`](http://r.esri.com/arcgisviz/reference/arcgisMapOutput.md)
  to update.

- session:

  default
  [`shiny::getDefaultReactiveDomain()`](https://rdrr.io/pkg/shiny/man/domains.html).
  Defines the Shiny session to send through.

## Value

An `ArcMapProxy`, which
[`add_layer()`](http://r.esri.com/arcgisviz/reference/add_layer.md) and
the map `set_*()` functions accept.

## Details

Only what changed crosses the wire. A basemap or view change carries no
data at all, and a layer already drawn is never resent - it is filtered,
highlighted, hidden or removed in place by
[`set_filter()`](http://r.esri.com/arcgisviz/reference/set_filter.md),
[`set_selection()`](http://r.esri.com/arcgisviz/reference/set_selection.md),
[`set_layer()`](http://r.esri.com/arcgisviz/reference/set_layer.md) and
[`remove_layer()`](http://r.esri.com/arcgisviz/reference/set_layer.md).

A layer added through a proxy must be named, because the name is what
identifies it to those functions. Adding one whose name is already on
the map replaces it.

## Examples

``` r
# Inside a Shiny server:
if (interactive()) {
  arc_map_proxy("map") |>
    set_basemap("satellite") |>
    arc_update()
}
```
