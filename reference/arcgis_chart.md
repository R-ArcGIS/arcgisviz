# Render an ArcGIS chart

Creates an htmlwidget wrapping the `<arcgis-chart>` web component. The
chart's model and layer are created client-side (in the browser) from
`i_layer` and `config` via the JS `createModel()` function - no live
ArcGIS Server feature service is required when `i_layer` is a
self-contained feature collection (see
[`as_chart_layer()`](http://r.esri.com/arcgisviz/reference/as_chart_layer.md)).

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

  A list giving the JSON layer definition (`IFeatureLayer`), e.g. built
  with
  [`as_chart_layer()`](http://r.esri.com/arcgisviz/reference/as_chart_layer.md).

- chart_type:

  A `ModelTypes` string, e.g. `"barChart"`. Used to build the default
  model that `config` is merged over.

- config:

  A list giving the chart config (`ChartConfig`, i.e. the `WebChart`
  shape). May be sparse - it is merged over the defaults client-side.

- width, height:

  Widget sizing, passed to
  [`htmlwidgets::createWidget()`](https://rdrr.io/pkg/htmlwidgets/man/createWidget.html).

- element_id:

  Optional DOM element ID for the widget.

## Details

Most users want
[`arc_bar()`](http://r.esri.com/arcgisviz/reference/arc_bar.md)/[`arc_scatter()`](http://r.esri.com/arcgisviz/reference/arc_scatter.md)/[`arc_line()`](http://r.esri.com/arcgisviz/reference/arc_line.md)
instead, which build both arguments for you.
