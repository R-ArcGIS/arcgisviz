# Histogram

Bins one numeric column and plots the frequency of each bin. The
frequency axis is derived, so there is no `y` to map.

## Usage

``` r
arc_histogram(.data, x, bins = NULL, transform = NULL)

set_histogram(chart, ..., bins = NULL, transform = NULL)
```

## Arguments

- .data:

  Defines which data frame the chart draws its fields from.

- x:

  Defines which numeric column is binned.

- bins:

  default `NULL`. Defines how many bins to split `x` into, or `NULL` to
  let the chart choose.

- transform:

  default `NULL`. Defines which transformation is applied before
  binning, one of `"none"`, `"log"`, or `"sqrt"`.

- chart:

  Defines which chart to modify.

- ...:

  These dots are for future extensions and must be empty.

## Value

An `ArcChart`.

## Details

`set_histogram()` reaches the same options later, for charts built with
[`set_type()`](http://r.esri.com/arcgisviz/reference/set_type.md) rather
than this shortcut.

## Examples

``` r
df <- data.frame(mass = c(1, 5, 3, 8, 2))

arc_histogram(df, mass, bins = 10)
```
