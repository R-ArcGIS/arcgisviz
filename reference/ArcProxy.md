# Update a rendered chart from the Shiny server

`arc_proxy()` wraps a chart that is already on screen. Every `set_*()`
function works on the result, and
[`arc_update()`](http://r.esri.com/arcgisviz/reference/arc_update.md)
sends the accumulated changes to the browser.

## Usage

``` r
ArcProxy(
  data = NULL,
  chart_type = NA_character_,
  x = NA_character_,
  y = NA_character_,
  stat = NA_character_,
  labs = list(),
  color = list(),
  size = list(),
  tooltip = character(0),
  axes = list(),
  legend = list(),
  flipped = NA,
  position = NA_character_,
  series_opts = list(),
  config_opts = list(),
  output_id = NA_character_,
  session = NULL
)

arc_proxy(output_id, chart, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- output_id:

  Defines which
  [`arcgisChartOutput()`](http://r.esri.com/arcgisviz/reference/arcgisChartOutput.md)
  to update.

- session:

  default
  [`shiny::getDefaultReactiveDomain()`](https://rdrr.io/pkg/shiny/man/domains.html).
  Defines the Shiny session to send through.

- chart:

  Defines the chart currently rendered there, so that the `set_*()`
  functions can validate against the same data.

## Value

An `ArcProxy`, which every `set_*()` function accepts.

## Details

The data never crosses the wire again. Only the configuration is resent,
and the browser merges it over the model it already built, so changing a
mapping on a large layer costs nothing beyond the config itself.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
chart <- arc_col(df, species, mass)

# Inside a Shiny server:
if (interactive()) {
  arc_proxy("chart", chart) |>
    set_color(species) |>
    arc_update()
}
```
