# Build a feature layer from a data frame

Wraps a data frame as a self-contained client side feature collection,
the `iLayer` the browser builds the chart from. No live feature service
is involved.

## Usage

``` r
as_chart_layer(
  .data,
  name = "chart_data",
  title = name,
  id = "arcgisviz-layer"
)
```

## Arguments

- .data:

  Defines which data frame or `sf` object to convert.

- name:

  default `"chart_data"`. Defines what the layer is named.

- title:

  default `name`. Defines the human readable layer title.

- id:

  default `"arcgisviz-layer"`. Defines the unique layer id.

## Value

A list holding the `IFeatureLayer` JSON shape.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

as_chart_layer(df)
#> Error in loadNamespace(x): there is no package called ‘arcgisutils’
```
