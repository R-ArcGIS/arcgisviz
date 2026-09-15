# WebChartNullCategory

How rows with a missing category are labelled and drawn.

## Usage

``` r
WebChartNullCategory(text = NA_character_, symbol = NULL)
```

## Arguments

- text:

  String.

- symbol:

  `NULL` or a `ISimpleFillSymbol` object.

## Value

An object of class `WebChartNullCategory`.

## Examples

``` r
WebChartNullCategory(
  text = "Unknown",
  symbol = ISimpleFillSymbol(color = Color(r = 200, g = 200, b = 200, a = 1))
)
#> <arcgisviz::WebChartNullCategory>
#>  @ text  : chr "Unknown"
#>  @ symbol: <arcgisviz::ISimpleFillSymbol>
#>  .. @ type   : chr "esriSFS"
#>  .. @ style  : <arcgisviz::SimpleFillSymbolStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:8] "esriSFSBackwardDiagonal" "esriSFSCross" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color  : <arcgisviz::Color>
#>  .. .. @ r: num 200
#>  .. .. @ g: num 200
#>  .. .. @ b: num 200
#>  .. .. @ a: num 1
#>  .. @ outline: NULL
```
