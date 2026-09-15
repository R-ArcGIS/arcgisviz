# A widget on a map

One `<arcgis-*>` component and the properties set on it. Built by
[`add_widget()`](http://r.esri.com/arcgisviz/reference/add_widget.md),
not called directly.

## Value

An object of class `MapWidget`.

## Examples

``` r
# add_widget() and the add_*() shortcuts build these.
map <- add_legend(arc_map(), position = "top-right", expand = TRUE)
map@widgets[[1]]
#> <arcgisviz::MapWidget>
#>  @ widget  : chr "legend"
#>  @ position: chr "top-right"
#>  @ expand  : logi TRUE
#>  @ props   : list()

# Every component the registry reaches.
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
