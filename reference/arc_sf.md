# Read what was drawn or edited on a map

Turns an `input$<output_id>$sketch` or `input$<output_id>$edits` event
into an `sf` object. Both carry their features as Esri feature JSON,
which is what
[`arcgisutils::parse_esri_json()`](https://rdrr.io/pkg/arcgisutils/man/parse_esri_json.html)
reads.

## Usage

``` r
arc_sf(x)
```

## Arguments

- x:

  Defines which event to read, from `input$<output_id>$sketch` or
  `input$<output_id>$edits`.

## Value

An `sf` object, or `NULL` when the event carried no features - a cleared
sketch, or an edit that only deleted.

## Details

A drawn shape is returned in longitude/latitude, since the view draws in
Web Mercator and metres are rarely what the next line of R wants. Edited
features come back in the layer's own coordinate reference system, the
one the data frame was sent in.

## Examples

``` r
# Inside a Shiny server:
if (interactive()) {
  observeEvent(input$map$sketch, {
    drawn <- arc_sf(input$map$sketch)
    print(sf::st_area(drawn))
  })
}
```
