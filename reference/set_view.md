# Set the initial view

Positions the map. Leave everything unset and the map frames its layers
instead.

## Usage

``` r
set_view(map, center = NULL, zoom = NULL, extent = NULL)
```

## Arguments

- map:

  Defines which map to modify.

- center:

  default `NULL`. Defines the centre as `c(longitude, latitude)`.

- zoom:

  default `NULL`. Defines the zoom level, from `0` (the world) to about
  `23`.

- extent:

  default `NULL`. Defines the visible extent as a named list of `xmin`,
  `ymin`, `xmax`, `ymax`, and `spatialReference`. Overrides `center` and
  `zoom`.

## Value

`map`, with the view set.

## Examples

``` r
set_view(arc_map(), center = c(-98.3, 38.2), zoom = 4)
#> Error in `method(as_widget, arcgisviz::ArcMap)`(x = <object>, width = NULL,     height = NULL, element_id = NULL): `x` has no layers to render.
```
