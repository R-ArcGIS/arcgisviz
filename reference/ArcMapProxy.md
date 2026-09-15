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
  widgets = list(),
  basemap = NA_character_,
  center = integer(0),
  zoom = NA_real_,
  extent = list(),
  highlight = list(),
  output_id = NA_character_,
  session = NULL
)

arc_map_proxy(output_id, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- layers:

  List.

- widgets:

  List.

- basemap:

  String.

- center:

  Number or Number.

- zoom:

  Number.

- extent:

  List.

- highlight:

  List.

- output_id:

  String.

- session:

  Any value.

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
