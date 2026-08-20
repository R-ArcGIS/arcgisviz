# Shiny bindings for arcgis_map

Place `arcgisMapOutput()` in a Shiny UI and `renderArcgisMap()` in the
server.

## Usage

``` r
arcgisMapOutput(outputId, width = "100%", height = "500px")

renderArcgisMap(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- outputId:

  Defines which output variable the map is read from.

- width, height:

  default `"100%"` and `"500px"`. Defines the output size, passed to
  [`htmlwidgets::shinyWidgetOutput()`](https://rdrr.io/pkg/htmlwidgets/man/htmlwidgets-shiny.html).

- expr:

  Defines the expression that generates the map.

- env:

  default [`parent.frame()`](https://rdrr.io/r/base/sys.parent.html).
  Defines where `expr` is evaluated.

- quoted:

  default `FALSE`. Defines whether `expr` is already quoted.

## Value

A Shiny output or render function.

## Examples

``` r
arcgisMapOutput("map")
#> <div class="arcgisMap html-widget html-widget-output shiny-report-size html-fill-item" id="map" style="width:100%;height:500px;"></div>
```
