# ModelTypes

The `@arcgis/charts-components` chart-type strings accepted by
`createModel()`, e.g. `"barChart"`, `"lineChart"`, `"scatterplot"`.

## Usage

``` r
ModelTypes(value = NA_character_)
```

## Arguments

- value:

  String. One of `"barChart"`, `"lineChart"`, `"comboBarLineChart"`,
  `"boxPlot"`, `"pieChart"`, `"scatterplot"`, `"histogram"`, `"gauge"`,
  `"radarChart"`, `"heatChart"`, `NA`.

## Value

An object of class `ModelTypes`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.
