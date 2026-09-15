# WebChartLineChartSeries

One series of a line chart. A radar chart reuses this class outright -
the spec declares its series as this interface with a different `type`.

## Usage

``` r
WebChartLineChartSeries(
  type = NA_character_,
  y = NA_character_,
  lineSymbol = NULL,
  lineSmoothed = NA,
  showArea = NA,
  markerVisible = NA,
  markerSymbol = NULL,
  areaColor = NULL,
  stackNegativeValuesToBaseline = NA,
  connectLines = NA,
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

- lineSymbol:

  `NULL` or a `ISimpleLineSymbol` object.

- lineSmoothed:

  Bool.

- showArea:

  Bool.

- markerVisible:

  Bool.

- markerSymbol:

  `NULL` or a `ISimpleMarkerSymbol` object.

- areaColor:

  `NULL` or a `Color` object.

- stackNegativeValuesToBaseline:

  Bool.

- connectLines:

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

An object of class `WebChartLineChartSeries`.

## Examples

``` r
WebChartLineChartSeries(
  type = "lineSeries",
  id = "series0",
  name = "mean(body_mass)",
  x = "year",
  y = "AVG_body_mass_0",
  lineSymbol = ISimpleLineSymbol(
    color = Color(r = 78, g = 121, b = 167, a = 1),
    width = 2
  )
)
#> <arcgisviz::WebChartLineChartSeries>
#>  @ type                         : chr "lineSeries"
#>  @ y                            : chr "AVG_body_mass_0"
#>  @ lineSymbol                   : <arcgisviz::ISimpleLineSymbol>
#>  .. @ type : chr "esriSLS"
#>  .. @ style: <arcgisviz::SimpleLineSymbolStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:6] "esriSLSDash" "esriSLSDashDot" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color: <arcgisviz::Color>
#>  .. .. @ r: num 78
#>  .. .. @ g: num 121
#>  .. .. @ b: num 167
#>  .. .. @ a: num 1
#>  .. @ width: num 2
#>  @ lineSmoothed                 : logi NA
#>  @ showArea                     : logi NA
#>  @ markerVisible                : logi NA
#>  @ markerSymbol                 : NULL
#>  @ areaColor                    : NULL
#>  @ stackNegativeValuesToBaseline: logi NA
#>  @ connectLines                 : logi NA
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
#>  @ x                            : chr "year"
#>  @ dataLabels                   : NULL
#>  @ assignToSecondValueAxis      : logi NA
#>  @ binTemporalData              : logi NA
#>  @ temporalBinning              : NULL

# The same class, as a radar series.
WebChartLineChartSeries(type = "radarSeries", x = "species", y = "count")
#> <arcgisviz::WebChartLineChartSeries>
#>  @ type                         : chr "radarSeries"
#>  @ y                            : chr "count"
#>  @ lineSymbol                   : NULL
#>  @ lineSmoothed                 : logi NA
#>  @ showArea                     : logi NA
#>  @ markerVisible                : logi NA
#>  @ markerSymbol                 : NULL
#>  @ areaColor                    : NULL
#>  @ stackNegativeValuesToBaseline: logi NA
#>  @ connectLines                 : logi NA
#>  @ nullCategory                 : NULL
#>  @ id                           : chr NA
#>  @ visible                      : logi NA
#>  @ dataTooltipVisible           : logi NA
#>  @ dataTooltipReverseColor      : logi NA
#>  @ dataTooltipValueFormat       : NULL
#>  @ dataTooltipPercentFormat     : NULL
#>  @ dataTooltipDateFormat        : NULL
#>  @ dataTooltipFontSize          : num NA
#>  @ name                         : chr NA
#>  @ query                        : NULL
#>  @ x                            : chr "species"
#>  @ dataLabels                   : NULL
#>  @ assignToSecondValueAxis      : logi NA
#>  @ binTemporalData              : logi NA
#>  @ temporalBinning              : NULL
```
