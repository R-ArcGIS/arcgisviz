# Build an `IFeatureLayer` from a data frame

Wraps `.data` as a self-contained client-side feature collection layer -
the `iLayer` argument of the JS `createModel()`. No live feature service
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

  A data frame (or `sf` object) to convert.

- name, title:

  Layer name and human-readable title.

- id:

  A unique layer id.

## Value

A list with the `IFeatureLayer` JSON shape.
