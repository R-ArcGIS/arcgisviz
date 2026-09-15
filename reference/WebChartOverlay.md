# WebChartOverlay

One overlay drawn over a chart's marks, such as a trend line. `created`
being true is also what gives a scatterplot or histogram a legend.

## Usage

``` r
WebChartOverlay(
  type = NA_character_,
  created = NA,
  visible = NA,
  symbol = NULL
)
```

## Arguments

- type:

  String.

- created:

  Bool.

- visible:

  Bool.

- symbol:

  `NULL` or a `ISimpleLineSymbol` object.

## Value

An object of class `WebChartOverlay`.

## Examples

``` r
WebChartOverlay(
  type = "chartOverlay",
  created = TRUE,
  visible = TRUE,
  symbol = ISimpleLineSymbol(
    style = SimpleLineSymbolStyle("esriSLSDash"),
    width = 1
  )
)
#> <arcgisviz::WebChartOverlay>
#>  @ type   : chr "chartOverlay"
#>  @ created: logi TRUE
#>  @ visible: logi TRUE
#>  @ symbol : <arcgisviz::ISimpleLineSymbol>
#>  .. @ type : chr "esriSLS"
#>  .. @ style: <arcgisviz::SimpleLineSymbolStyle>
#>  .. .. @ value   : chr "esriSLSDash"
#>  .. .. @ variants: chr [1:6] "esriSLSDash" "esriSLSDashDot" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color: NULL
#>  .. @ width: num 1
```
