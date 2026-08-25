# Every widget a map can carry

One row per component
[`add_widget()`](http://r.esri.com/arcgisviz/reference/add_widget.md)
accepts, with the corner it defaults to and the properties it takes.

## Usage

``` r
map_widgets()
```

## Value

A data frame of `widget`, `component`, `position`, and `properties`.

## Examples

``` r
map_widgets()
#> # A data frame: 18 × 4
#>    widget                component                      position    properties
#>  * <chr>                 <chr>                          <chr>       <list>    
#>  1 legend                arcgis-legend                  bottom-left <chr [9]> 
#>  2 layer-list            arcgis-layer-list              top-right   <chr [18]>
#>  3 basemap-gallery       arcgis-basemap-gallery         top-right   <chr [4]> 
#>  4 basemap-toggle        arcgis-basemap-toggle          bottom-left <chr [4]> 
#>  5 search                arcgis-search                  top-right   <chr [17]>
#>  6 bookmarks             arcgis-bookmarks               top-right   <chr [17]>
#>  7 zoom                  arcgis-zoom                    top-left    <chr [4]> 
#>  8 home                  arcgis-home                    top-left    <chr [3]> 
#>  9 compass               arcgis-compass                 top-left    <chr [3]> 
#> 10 fullscreen            arcgis-fullscreen              top-left    <chr [2]> 
#> 11 locate                arcgis-locate                  top-left    <chr [6]> 
#> 12 track                 arcgis-track                   top-left    <chr [6]> 
#> 13 sketch                arcgis-sketch                  top-right   <chr [24]>
#> 14 editor                arcgis-editor                  top-right   <chr [13]>
#> 15 area-measurement      arcgis-area-measurement-2d     top-right   <chr [7]> 
#> 16 distance-measurement  arcgis-distance-measurement-2d top-right   <chr [7]> 
#> 17 scale-bar             arcgis-scale-bar               bottom-left <chr [4]> 
#> 18 coordinate-conversion arcgis-coordinate-conversion   bottom-left <chr [13]>
```
