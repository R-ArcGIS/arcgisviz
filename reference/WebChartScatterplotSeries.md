# WebChartScatterplotSeries

The scatterplot's series. It is the only one in the spec that can name
extra tooltip fields (`additionalTooltipFields`) or size its markers by
a column (`sizePolicy`), which is why
[`set_size()`](http://r.esri.com/arcgisviz/reference/set_size.md) and
the native tooltip path are scatter-only.

## Usage

``` r
WebChartScatterplotSeries(
  type = NA_character_,
  y = NA_character_,
  markerSymbol = NULL,
  overlays = NULL,
  sizePolicy = NULL,
  additionalTooltipFields = character(0),
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
  assignToSecondValueAxis = NA
)
```

## Arguments

- type:

  String.

- y:

  String.

- markerSymbol:

  `NULL` or a `ISimpleMarkerSymbol` object.

- overlays:

  `NULL` or a `ScatterplotOverlays` object.

- sizePolicy:

  `NULL` or a `SizePolicy` object.

- additionalTooltipFields:

  String.

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

## Value

An object of class `WebChartScatterplotSeries`.

## Examples

``` r
WebChartScatterplotSeries(
  type = "scatterSeries",
  id = "series0",
  name = "bill_dep",
  x = "bill_len",
  y = "bill_dep",
  additionalTooltipFields = c("island", "body_mass"),
  sizePolicy = SizePolicy(type = "sizeScale", field = "body_mass")
)
#> <arcgisviz::WebChartScatterplotSeries>
#>  @ type                    : chr "scatterSeries"
#>  @ y                       : chr "bill_dep"
#>  @ markerSymbol            : NULL
#>  @ overlays                : NULL
#>  @ sizePolicy              : <arcgisviz::SizePolicy>
#>  .. @ type     : chr "sizeScale"
#>  .. @ scaleType: <arcgisviz::SizePolicyScaleTypes>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "linear" "logarithmic"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ field    : chr "body_mass"
#>  .. @ minSize  : num NA
#>  .. @ maxSize  : num NA
#>  @ additionalTooltipFields : chr [1:2] "island" "body_mass"
#>  @ id                      : chr "series0"
#>  @ visible                 : logi NA
#>  @ dataTooltipVisible      : logi NA
#>  @ dataTooltipReverseColor : logi NA
#>  @ dataTooltipValueFormat  : NULL
#>  @ dataTooltipPercentFormat: NULL
#>  @ dataTooltipDateFormat   : NULL
#>  @ dataTooltipFontSize     : num NA
#>  @ name                    : chr "bill_dep"
#>  @ query                   : NULL
#>  @ x                       : chr "bill_len"
#>  @ dataLabels              : NULL
#>  @ assignToSecondValueAxis : logi NA
```
