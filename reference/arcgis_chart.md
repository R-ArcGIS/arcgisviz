# Render an ArcGIS chart

Creates an htmlwidget wrapping the `<arcgis-chart>` web component. The
chart's model and layer are created client-side (in the browser) from
`i_layer` via the JS `createModel()` function - no live ArcGIS Server
feature service is required when `i_layer` is a self-contained feature
collection (see `arcgisutils::as_layer()`/`as_feature_collection()`).

## Usage

``` r
arcgis_chart(
  i_layer,
  chart_type = "barChart",
  x_field = NULL,
  y_field = NULL,
  width = NULL,
  height = NULL,
  element_id = NULL
)
```

## Arguments

- i_layer:

  A list giving the JSON layer definition (`IFeatureLayer`), e.g. built
  with `arcgisutils::as_layer()`.

- chart_type:

  One of the `@arcgis/charts-components` `ModelTypes` strings, e.g.
  `"barChart"`, `"lineChart"`, `"scatterplot"`. Validated against
  [`ModelTypes()`](http://r.esri.com/arcgisviz/reference/ModelTypes.md).

- x_field, y_field:

  Field names to assign to the chart's x/y axes.

- width, height:

  Widget sizing, passed to
  [`htmlwidgets::createWidget()`](https://rdrr.io/pkg/htmlwidgets/man/createWidget.html).

- element_id:

  Optional DOM element ID for the widget.
