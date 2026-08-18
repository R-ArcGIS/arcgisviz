# Bar chart

Counts rows per `x`. Use
[`arc_col()`](http://r.esri.com/arcgisviz/reference/arc_col.md) for
values you have already summarised or
[`set_stat()`](http://r.esri.com/arcgisviz/reference/set_stat.md) for
any other aggregation.

## Usage

``` r
arc_bar(.data, x)
```

## Arguments

- .data:

  Defines which data frame the chart draws its fields from.

- x:

  Defines which column the bars are grouped by.

## Value

An `ArcChart`.

## Examples

``` r
df <- data.frame(species = c("a", "a", "b"), mass = c(1, 5, 3))

arc_bar(df, species)
```
