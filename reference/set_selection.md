# Select features on a rendered chart or map

Marks rows as selected by object id. A chart draws them as its own
selection; a map hands them to the view's selection manager, which
highlights them and reports the new selection back as
`input$<output_id>$selection`. Object ids are row numbers, so a chart
and a map built from the same data frame select each other's rows.

## Usage

``` r
set_selection(proxy, object_ids, ...)
```

## Arguments

- proxy:

  Defines which
  [`arc_proxy()`](http://r.esri.com/arcgisviz/reference/ArcProxy.md) or
  [`arc_map_proxy()`](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
  to select on.

- object_ids:

  Defines which rows to select, by object id. An empty vector clears the
  selection.

- ...:

  Reserved for methods.

- layer:

  default `NULL`. Defines which map layer to select in, by name. `NULL`
  selects in every layer. Maps only.

- mode:

  default `"replace"`. Defines what these ids do to the current
  selection, one of `"replace"`, `"add"`, `"remove"`, or `"toggle"`.
  Maps only.

## Value

`proxy`, invisibly.

## Details

On a map the selection is a set that persists across calls, which is
what `mode` operates on and what a click on a `selectable` layer
([`add_layer()`](http://r.esri.com/arcgisviz/reference/add_layer.md)) or
a drawn
[`arc_draw_selection()`](http://r.esri.com/arcgisviz/reference/arc_draw_selection.md)
shape adds to.
[`set_highlight()`](http://r.esri.com/arcgisviz/reference/set_highlight.md)
styles it and
[`arc_selected()`](http://r.esri.com/arcgisviz/reference/arc_selected.md)
reads it.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

if (interactive()) {
  arc_proxy("chart", arc_col(df, species, mass)) |>
    set_selection(c(1, 2))
}
```
