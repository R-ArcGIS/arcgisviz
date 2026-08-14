# Convert a chart to an htmlwidget

Converts an
[`arc_chart()`](http://r.esri.com/arcgisviz/reference/arc_chart.md)
object into a renderable htmlwidget: its data becomes a client-side
feature collection layer, and its config is sent as the `config`
argument of the JS `createModel()`.

## Usage

``` r
as_widget(chart, width = NULL, height = NULL, element_id = NULL)
```

## Arguments

- chart:

  An `ArcChart`, from
  [`arc_chart()`](http://r.esri.com/arcgisviz/reference/arc_chart.md) or
  one of
  [`arc_bar()`](http://r.esri.com/arcgisviz/reference/arc_bar.md),
  [`arc_scatter()`](http://r.esri.com/arcgisviz/reference/arc_scatter.md),
  [`arc_line()`](http://r.esri.com/arcgisviz/reference/arc_line.md).

- width, height:

  Widget sizing, passed to
  [`htmlwidgets::createWidget()`](https://rdrr.io/pkg/htmlwidgets/man/createWidget.html).

- element_id:

  Optional DOM element ID for the widget.

## Value

An htmlwidget.
