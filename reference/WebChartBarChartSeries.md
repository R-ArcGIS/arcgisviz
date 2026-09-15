# WebChartBarChartSeries

One series of a bar chart. Built for you by the
[`arc_bar()`](http://r.esri.com/arcgisviz/reference/arc_bar.md)
pipeline; a grouped chart gets one of these per level.

## Usage

``` r
WebChartBarChartSeries(
  type = NA_character_,
  y = NA_character_,
  fillSymbol = NULL,
  hideOversizedStackedLabels = NA,
  hideOversizedSideBySideLabels = NA,
  nullCategory = NULL,
  id = NA_character_,
  visible = NA,
  dataTooltipVisible = NA,
  dataTooltipReverseColor = NA,
  dataTooltipValueFormat = NULL,
  dataTooltipPercentFormat = NULL,
  dataTooltipDateFormat = NULL,
  dataTooltipFontSize = NA_real_,
  name = NA_character_,
  query = NULL,
  x = NA_character_,
  dataLabels = NULL,
  assignToSecondValueAxis = NA,
  binTemporalData = NA,
  temporalBinning = NULL
)
```

## Arguments

- type:

  String.

- y:

  String.

- fillSymbol:

  `NULL` or a `ISimpleFillSymbol` object.

- hideOversizedStackedLabels:

  Bool.

- hideOversizedSideBySideLabels:

  Bool.

- nullCategory:

  `NULL` or a `WebChartNullCategory` object.

- id:

  String.

- visible:

  Bool.

- dataTooltipVisible:

  Bool.

- dataTooltipReverseColor:

  Bool.

- dataTooltipValueFormat:

  `NULL` or a `NumberFormatOptions` object.

- dataTooltipPercentFormat:

  `NULL` or a `NumberFormatOptions` object.

- dataTooltipDateFormat:

  `NULL` or a `DateTimeFormatOptions` object.

- dataTooltipFontSize:

  Number.

- name:

  String.

- query:

  `NULL` or a `WebChartSeriesQuery` object.

- x:

  String.

- dataLabels:

  `NULL` or a `WebChartText` object.

- assignToSecondValueAxis:

  Bool.

- binTemporalData:

  Bool.

- temporalBinning:

  `NULL` or a `WebChartTemporalBinning` object.

## Value

An object of class `WebChartBarChartSeries`.

## Examples

``` r
WebChartBarChartSeries(
  type = "barSeries",
  id = "series0",
  name = "mean(body_mass)",
  x = "species",
  y = "AVG_body_mass_0",
  fillSymbol = ISimpleFillSymbol(
    color = Color(r = 78, g = 121, b = 167, a = 1)
  )
)
#> <arcgisviz::WebChartBarChartSeries>
#>  @ type                         : chr "barSeries"
#>  @ y                            : chr "AVG_body_mass_0"
#>  @ fillSymbol                   : <arcgisviz::ISimpleFillSymbol>
#>  .. @ type   : chr "esriSFS"
#>  .. @ style  : <arcgisviz::SimpleFillSymbolStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:8] "esriSFSBackwardDiagonal" "esriSFSCross" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color  : <arcgisviz::Color>
#>  .. .. @ r: num 78
#>  .. .. @ g: num 121
#>  .. .. @ b: num 167
#>  .. .. @ a: num 1
#>  .. @ outline: NULL
#>  @ hideOversizedStackedLabels   : logi NA
#>  @ hideOversizedSideBySideLabels: logi NA
#>  @ nullCategory                 : NULL
#>  @ id                           : chr "series0"
#>  @ visible                      : logi NA
#>  @ dataTooltipVisible           : logi NA
#>  @ dataTooltipReverseColor      : logi NA
#>  @ dataTooltipValueFormat       : NULL
#>  @ dataTooltipPercentFormat     : NULL
#>  @ dataTooltipDateFormat        : NULL
#>  @ dataTooltipFontSize          : num NA
#>  @ name                         : chr "mean(body_mass)"
#>  @ query                        : NULL
#>  @ x                            : chr "species"
#>  @ dataLabels                   : NULL
#>  @ assignToSecondValueAxis      : logi NA
#>  @ binTemporalData              : logi NA
#>  @ temporalBinning              : NULL
```
