# Select features by drawing on the map

Hands the reader a drawing tool. Whatever the shape they draw covers
becomes the selection, which arrives back as
`input$<output_id>_selection` the same way
[`set_selection()`](http://r.esri.com/arcgisviz/reference/set_selection.md)'s
does. The tool is live from the moment this is called and is put away
once the shape is finished.

## Usage

``` r
arc_draw_selection(proxy, tool = "rectangle", mode = "replace", layer = NULL)
```

## Arguments

- proxy:

  Defines which
  [`arc_map_proxy()`](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
  to draw on.

- tool:

  default `"rectangle"`. Defines what the reader draws, one of
  `"rectangle"`, `"polygon"`, `"lasso"`, `"circle"`, or `"point"`.

- mode:

  default `"replace"`. Defines what the drawn shape does to the existing
  selection, one of `"replace"`, `"add"`, or `"remove"`.

- layer:

  default `NULL`. Defines which layers can be selected in, by name.
  `NULL` means every layer on the map.

## Value

`proxy`, invisibly.

## Examples

``` r
if (interactive()) {
  arc_map_proxy("map") |>
    arc_draw_selection(tool = "lasso")
}
```
