# Invoke a rendered chart's own methods

Each of these calls a method on the `<arcgis-chart>` element directly.
The two export functions download in the reader's browser.

## Usage

``` r
arc_refresh(proxy, update_data = TRUE, reset_axes = FALSE)

arc_reset_zoom(proxy)

arc_clear_selection(proxy)

arc_export_image(proxy, format = "png")

arc_export_csv(proxy)

arc_notify(proxy, message, heading = NULL)
```

## Arguments

- proxy:

  Defines which
  [`arc_proxy()`](http://r.esri.com/arcgisviz/reference/ArcProxy.md) to
  act on.

- update_data:

  default `TRUE`. Defines whether `arc_refresh()` requeries the layer or
  only redraws.

- reset_axes:

  default `FALSE`. Defines whether axis bounds are recomputed.

- format:

  default `"png"`. Defines the image format, one of `"png"`, `"jpeg"`,
  or `"svg"`.

- message, heading:

  Defines the text `arc_notify()` shows in the chart's own info panel.

## Value

`proxy`, invisibly.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

if (interactive()) {
  arc_proxy("chart", arc_col(df, species, mass)) |>
    arc_reset_zoom()
}
```
