# Gauge

Draws a single number on a dial. A gauge reads one value, so `x` names
the column it comes from and
[`set_stat()`](http://r.esri.com/arcgisviz/reference/set_stat.md)
decides how the column is reduced to that value - or `feature` picks one
row verbatim.

## Usage

``` r
arc_gauge(
  .data,
  x,
  stat = "mean",
  feature = NULL,
  hole = NULL,
  angles = NULL,
  needle = NULL
)

set_gauge(
  chart,
  ...,
  feature = NULL,
  hole = NULL,
  angles = NULL,
  needle = NULL
)
```

## Arguments

- .data:

  Defines which data frame the chart draws its fields from.

- x:

  Defines which numeric column the reading comes from.

- stat:

  default `"mean"`. Defines how the column is reduced to one value. See
  [`set_stat()`](http://r.esri.com/arcgisviz/reference/set_stat.md).

- feature:

  default `NULL`. Defines which row to read verbatim, by position.
  Setting it overrides `stat`.

- hole:

  default `NULL`. Defines the size of the hole in the middle as a
  percentage of the radius.

- angles:

  default `NULL`. Defines the dial's start and end angle in degrees, as
  `c(start, end)`.

- needle:

  default `NULL`. Defines whether the needle is drawn.

- chart:

  Defines which chart to modify.

- ...:

  These dots are for future extensions and must be empty.

## Value

An `ArcChart`.

## Details

`set_gauge()` reaches the same options later, for charts built with
[`set_type()`](http://r.esri.com/arcgisviz/reference/set_type.md) rather
than this shortcut.

## Examples

``` r
df <- data.frame(mass = c(1, 5, 3))

arc_gauge(df, mass, stat = "mean")
```
