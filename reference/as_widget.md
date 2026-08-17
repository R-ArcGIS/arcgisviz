# Convert a chart to an htmlwidget

Turns an
[`arc_chart()`](http://r.esri.com/arcgisviz/reference/arc_chart.md) into
a renderable widget. Printing an `ArcChart` calls this for you.

## Usage

``` r
as_widget(chart, width = NULL, height = NULL, element_id = NULL)
```

## Arguments

- chart:

  Defines which chart to render.

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

as_widget(arc_col(df, species, mass))
#> Error in loadNamespace(x): there is no package called ‘arcgisutils’
```
