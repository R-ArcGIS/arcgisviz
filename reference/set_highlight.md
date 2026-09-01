# Style the selection highlight

Changes how selected features are drawn. Works on an
[`arc_map()`](http://r.esri.com/arcgisviz/reference/arc_map.md) before
it is rendered and on an
[`arc_map_proxy()`](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
after, and applies to every selection - the ones
[`set_selection()`](http://r.esri.com/arcgisviz/reference/set_selection.md)
makes, the ones a click on a `selectable` layer makes, and the ones
[`arc_draw_selection()`](http://r.esri.com/arcgisviz/reference/arc_draw_selection.md)
draws.

## Usage

``` r
set_highlight(
  map,
  color = NULL,
  halo_opacity = NULL,
  fill_opacity = NULL,
  shadow_color = NULL,
  shadow_opacity = NULL,
  shadow_difference = NULL
)
```

## Arguments

- map:

  Defines which map or proxy to modify.

- color:

  default `NULL`. Defines the highlight colour, as a name or hex string.

- halo_opacity:

  default `NULL`. Defines the opacity of the outline drawn around a
  selected feature, from `0` to `1`.

- fill_opacity:

  default `NULL`. Defines the opacity of the fill drawn over a selected
  feature, from `0` to `1`.

- shadow_color:

  default `NULL`. Defines the colour of the shadow cast over everything
  that is *not* selected.

- shadow_opacity:

  default `NULL`. Defines that shadow's opacity, from `0` to `1`.

- shadow_difference:

  default `NULL`. Defines how much the shadow dims the unselected
  features, from `0` to `1`.

## Value

`map`, with the highlight style set.

## Examples

``` r
arc_map() |>
  set_highlight(color = "orange", fill_opacity = 0.4)
```
