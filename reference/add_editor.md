# Add an editor

Lets the reader change the features on the map - move them, retype their
attributes, add and delete. Edits happen in the browser and arrive in
Shiny as `input$<output_id>$edits`; nothing is written back to the data
frame the layer came from unless R does it.

## Usage

``` r
add_editor(
  map,
  position = NULL,
  expand = FALSE,
  hide_create_features_section = NULL,
  sync_view_selection = NULL,
  ...
)
```

## Arguments

- map:

  Defines which map or
  [`arc_map_proxy()`](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
  to modify.

- position:

  default `NULL`. Defines which corner it sits in, one of `"top-left"`,
  `"top-right"`, `"bottom-left"`, `"bottom-right"`, or the
  direction-aware `"top-start"`, `"top-end"`, `"bottom-start"`,
  `"bottom-end"`. Each widget has its own default.

- expand:

  default `FALSE`. Defines whether the widget is collapsed behind a
  button rather than drawn open. Worth it for the panels - the legend,
  layer list, basemap gallery - which otherwise cover the map. Collapsed
  widgets sharing a corner close each other when opened.

- hide_create_features_section:

  default `NULL`. Defines whether the "add a feature" half of the panel
  is hidden, leaving editing only.

- sync_view_selection:

  default `NULL`. Defines whether the editor and the map share one
  selection.

- ...:

  Named properties of the component itself, written either `snake_case`
  or `camelCase`.
  [`map_widgets()`](http://r.esri.com/arcgisviz/reference/map_widgets.md)
  lists what each one takes.

## Value

`map`, with the widget added.

## Examples

``` r
arc_map() |> add_editor(position = "top-right")
#> Error in `method(as_widget, arcgisviz::ArcMap)`(x = <object>, width = NULL,     height = NULL, element_id = NULL): `x` has no layers to render.
```
