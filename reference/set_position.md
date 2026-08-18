# Arrange grouped bars and lines

Places the groups that
[`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md)
creates beside each other, on top of each other, or stretched to fill
the axis. A chart with a single group has nothing to arrange, so this
does nothing until a colour column other than `x` splits it.

## Usage

``` r
set_position(chart, position = "dodge")
```

## Arguments

- chart:

  Defines which chart to modify.

- position:

  default `"dodge"`. Defines how the groups are placed, one of
  `"dodge"`, `"stack"`, or `"fill"`.

## Value

`chart`, with its position adjustment set.

## Examples

``` r
df <- data.frame(
  species = c("a", "a", "b"),
  island = c("x", "y", "x")
)

arc_bar(df, species) |>
  set_color(island) |>
  set_position("stack")
```
