# WebChartCursorCrosshair

WebChartCursorCrosshair

## Usage

``` r
WebChartCursorCrosshair(
  type = NA_character_,
  style = NULL,
  verticalLineVisible = NA,
  horizontalLineVisible = NA
)
```

## Arguments

- type:

  String.

- style:

  `NULL` or a `ISimpleLineSymbol` object.

- verticalLineVisible:

  Bool.

- horizontalLineVisible:

  Bool.

## Value

An object of class `WebChartCursorCrosshair`.

## Examples

``` r
WebChartCursorCrosshair(
  type = "chartCursorCrosshair",
  verticalLineVisible = TRUE,
  horizontalLineVisible = FALSE
)
#> <arcgisviz::WebChartCursorCrosshair>
#>  @ type                 : chr "chartCursorCrosshair"
#>  @ style                : NULL
#>  @ verticalLineVisible  : logi TRUE
#>  @ horizontalLineVisible: logi FALSE
```
