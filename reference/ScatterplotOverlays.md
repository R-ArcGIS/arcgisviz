# ScatterplotOverlays

The overlays a scatterplot supports - a trend line, and nothing else.

## Usage

``` r
ScatterplotOverlays(type = NA_character_, trendLine = NULL)
```

## Arguments

- type:

  String.

- trendLine:

  `NULL` or a `WebChartOverlay` object.

## Value

An object of class `ScatterplotOverlays`.

## Examples

``` r
ScatterplotOverlays(
  type = "scatterPlotOverlays",
  trendLine = WebChartOverlay(created = TRUE, visible = TRUE)
)
#> <arcgisviz::ScatterplotOverlays>
#>  @ type     : chr "scatterPlotOverlays"
#>  @ trendLine: <arcgisviz::WebChartOverlay>
#>  .. @ type   : chr NA
#>  .. @ created: logi TRUE
#>  .. @ visible: logi TRUE
#>  .. @ symbol : NULL
```
