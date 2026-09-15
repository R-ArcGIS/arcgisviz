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
  alpha = NA_real_,
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

- data:

  Any value.

- chart_type:

  String.

- x:

  String.

- y:

  String.

- stat:

  String.

- labs:

  List.

- color:

  List.

- alpha:

  Number.

- size:

  List.

- tooltip:

  String.

- axes:

  List.

- legend:

  List.

- flipped:

  Bool.

- position:

  String.

- series_opts:

  List.

- config_opts:

  List.

- output_id:

  String.

- session:

  Any value.

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
