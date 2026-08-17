# WebChartQuerySpatialRelationship

One of `"contains"`, `"crosses"`, `"disjoint"`, `"envelope-intersects"`,
`"index-intersects"`, `"intersects"`, `"overlaps"`, `"relation"`,
`"touches"`, `"within"`, `NA`.

## Usage

``` r
WebChartQuerySpatialRelationship(value = NA_character_)
```

## Arguments

- value:

  String. One of `"contains"`, `"crosses"`, `"disjoint"`,
  `"envelope-intersects"`, `"index-intersects"`, `"intersects"`,
  `"overlaps"`, `"relation"`, `"touches"`, `"within"`, `NA`.

## Value

An object of class `WebChartQuerySpatialRelationship`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.
