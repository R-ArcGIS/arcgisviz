# Box plot

Draws the five number summary of `y` for each value of `x`.

## Usage

``` r
arc_boxplot(.data, x, y, outliers = NULL, standardize = NULL)

set_boxplot(chart, ..., outliers = NULL, standardize = NULL)
```

## Arguments

- .data:

  Defines which data frame the chart draws its fields from.

- x:

  Defines which column the boxes are grouped by.

- y:

  Defines which numeric column is summarised.

- outliers:

  default `NULL`. Defines whether points beyond the whiskers are drawn.

- standardize:

  default `NULL`. Defines whether values are replaced by their z scores,
  putting every box on a comparable scale.

- chart:

  Defines which chart to modify.

- ...:

  These dots are for future extensions and must be empty.

## Value

An `ArcChart`.

## Details

`set_boxplot()` reaches the same options later, for charts built with
[`set_type()`](http://r.esri.com/arcgisviz/reference/set_type.md) rather
than this shortcut.

## Examples

``` r
df <- data.frame(species = c("a", "a", "b"), mass = c(1, 5, 3))

arc_boxplot(df, species, mass, outliers = FALSE)
```
