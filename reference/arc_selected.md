# Read a map selection

Pulls the object ids out of an `input$<output_id>_selection` event. A
selection can span several layers, so `layer` narrows it to one.

## Usage

``` r
arc_selected(x, layer = NULL)
```

## Arguments

- x:

  Defines which selection event to read.

- layer:

  default `NULL`. Defines which layer's ids to return, by name. `NULL`
  returns every selected id, across layers.

## Value

An integer vector of object ids.

## Examples

``` r
event <- list(
  count = 3,
  layers = list(list(layer = "Counties", objectIds = c(1, 2, 5)))
)

arc_selected(event)
#> [1] 1 2 5
arc_selected(event, layer = "Counties")
#> [1] 1 2 5
```
