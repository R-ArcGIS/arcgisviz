# Render an ArcGIS chart

Wraps the `<arcgis-chart>` web component directly. Most users want
[`arc_bar()`](http://r.esri.com/arcgisviz/reference/arc_bar.md),
[`arc_scatter()`](http://r.esri.com/arcgisviz/reference/arc_scatter.md),
or [`arc_line()`](http://r.esri.com/arcgisviz/reference/arc_line.md),
which build the arguments for you.

## Usage

``` r
arcgis_chart(
  i_layer,
  chart_type,
  config,
  width = NULL,
  height = NULL,
  element_id = NULL
)
```

## Arguments

- i_layer:

  Defines the layer the chart reads, as built by
  [`as_chart_layer()`](http://r.esri.com/arcgisviz/reference/as_chart_layer.md).

- chart_type:

  Defines which default model the config merges over, such as
  `"barChart"`. See
  [ModelTypes](http://r.esri.com/arcgisviz/reference/ModelTypes.md).

- config:

  Defines the chart configuration in the `WebChart` shape. May be sparse
  because the browser merges it over the defaults.

- width, height:

  default `NULL`. Defines the widget size, passed to
  [`htmlwidgets::createWidget()`](https://rdrr.io/pkg/htmlwidgets/man/createWidget.html).

- element_id:

  default `NULL`. Defines the DOM element id to render into.

## Value

An htmlwidget.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

arcgis_chart(
  i_layer = as_chart_layer(df),
  chart_type = "barChart",
  config = s7x::as_vector(arc_col(df, species, mass)@webchart)
)
#> Error in loadNamespace(x): there is no package called ‘arcgisutils’
```
