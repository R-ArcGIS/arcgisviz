# Pie chart

Draws one slice per value of `x`, sized by how many rows fall into it.
Use [`set_stat()`](http://r.esri.com/arcgisviz/reference/set_stat.md)
for any other aggregation, or `y` for values you have already
summarised.

## Usage

``` r
arc_pie(.data, x, y = NULL, hole = NULL, labels = NULL, inside = NULL)

set_pie(chart, ..., hole = NULL, labels = NULL, inside = NULL)
```

## Arguments

- .data:

  Defines which data frame the chart draws its fields from.

- x:

  Defines which column the slices are cut from.

- y:

  default `NULL`. Defines which column sizes each slice. Omit it to
  count rows instead.

- hole:

  default `NULL`. Defines the size of the hole in the middle as a
  percentage of the radius, turning the pie into a doughnut.

- labels:

  default `NULL`. Defines what each slice's label shows, any of
  `"category"`, `"value"`, and `"percent"`.

- inside:

  default `NULL`. Defines whether the labels sit inside the slices.

- chart:

  Defines which chart to modify.

- ...:

  These dots are for future extensions and must be empty.

## Value

An `ArcChart`.

## Details

`set_pie()` reaches the same options later, for charts built with
[`set_type()`](http://r.esri.com/arcgisviz/reference/set_type.md) rather
than this shortcut.

## Examples

``` r
df <- data.frame(species = c("a", "a", "b"), mass = c(1, 5, 3))

arc_pie(df, species, hole = 60)
```
