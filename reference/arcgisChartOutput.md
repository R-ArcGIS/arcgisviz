# Shiny bindings for arcgis_chart

Place `arcgisChartOutput()` in a Shiny UI and `renderArcgisChart()` in
the server.

## Usage

``` r
arcgisChartOutput(outputId, width = "100%", height = "400px")

renderArcgisChart(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- outputId:

  Defines which output variable the chart is read from.

- width, height:

  default `"100%"` and `"400px"`. Defines the output size, passed to
  [`htmlwidgets::shinyWidgetOutput()`](https://rdrr.io/pkg/htmlwidgets/man/htmlwidgets-shiny.html).

- expr:

  Defines the expression that generates the chart.

- env:

  default [`parent.frame()`](https://rdrr.io/r/base/sys.parent.html).
  Defines where `expr` is evaluated.

- quoted:

  default `FALSE`. Defines whether `expr` is already quoted.

## Value

A Shiny output or render function.

## Examples

``` r
arcgisChartOutput("chart")
#> <div class="arcgisChart html-widget html-widget-output shiny-report-size html-fill-item" id="chart" style="width:100%;height:400px;"></div>
```
