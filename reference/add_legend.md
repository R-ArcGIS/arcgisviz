# Add a legend

Draws one entry per layer, reading each layer's renderer - so a map with
`add_layer(color = )` explains its own colours.

## Usage

``` r
add_legend(
  map,
  position = NULL,
  expand = FALSE,
  legend_style = NULL,
  card_style_layout = NULL,
  basemap_legend_visible = NULL,
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

- legend_style:

  default `NULL`. Defines the layout, `"classic"` or `"card"`.

- card_style_layout:

  default `NULL`. Defines how cards are arranged when `legend_style` is
  `"card"`, `"auto"`, `"side-by-side"`, or `"stack"`.

- basemap_legend_visible:

  default `NULL`. Defines whether the basemap's own layers get legend
  entries.

- ...:

  Named properties of the component itself, written either `snake_case`
  or `camelCase`.
  [`map_widgets()`](http://r.esri.com/arcgisviz/reference/map_widgets.md)
  lists what each one takes.

## Value

`map`, with the widget added.

## Examples

``` r
arc_map() |> add_legend(expand = TRUE)
```
