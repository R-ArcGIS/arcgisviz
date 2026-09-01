# Add a drawing tool

Hands the reader tools to draw with. What they draw arrives in Shiny as
`input$<output_id>$sketch`, which
[`arc_sf()`](http://r.esri.com/arcgisviz/reference/arc_sf.md) turns into
an `sf` object.

## Usage

``` r
add_sketch(
  map,
  position = NULL,
  expand = FALSE,
  tools = NULL,
  creation_mode = NULL,
  layout = NULL,
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

- tools:

  default `NULL`. Defines which tools are offered, any of `"point"`,
  `"polyline"`, `"polygon"`, `"rectangle"`, `"circle"`, `"multipoint"`,
  `"freehandPolyline"`, and `"freehandPolygon"`.

- creation_mode:

  default `NULL`. Defines what happens after a shape is finished, one of
  `"single"`, `"continuous"`, or `"update"`.

- layout:

  default `NULL`. Defines the toolbar direction, `"vertical"` or
  `"horizontal"`.

- ...:

  Named properties of the component itself, written either `snake_case`
  or `camelCase`.
  [`map_widgets()`](http://r.esri.com/arcgisviz/reference/map_widgets.md)
  lists what each one takes.

## Value

`map`, with the widget added.

## Examples

``` r
arc_map() |> add_sketch(tools = c("polygon", "rectangle"))
```
