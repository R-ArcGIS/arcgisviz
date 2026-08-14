# Shiny bindings for arcgis_chart

Shiny bindings for arcgis_chart

## Usage

``` r
arcgisChartOutput(outputId, width = "100%", height = "400px")

renderArcgisChart(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- outputId:

  Output variable to read the chart from.

- width, height:

  Sizing, passed to
  [`htmlwidgets::shinyWidgetOutput()`](https://rdrr.io/pkg/htmlwidgets/man/htmlwidgets-shiny.html).

- expr:

  An expression that generates an `arcgis_chart`.

- env:

  The environment in which to evaluate `expr`.

- quoted:

  Is `expr` a quoted expression (with
  [`quote()`](https://rdrr.io/r/base/substitute.html))? This is useful
  if you want to save an expression in a variable.
