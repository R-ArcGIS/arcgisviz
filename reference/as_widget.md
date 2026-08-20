# Convert a chart or map to an htmlwidget

Turns an
[`arc_chart()`](http://r.esri.com/arcgisviz/reference/arc_chart.md) or
an [`arc_map()`](http://r.esri.com/arcgisviz/reference/arc_map.md) into
a renderable widget. Printing either one calls this for you.

## Usage

``` r
as_widget(x, width = NULL, height = NULL, element_id = NULL)
```

## Arguments

- x:

  Defines which chart or map to render.

- width, height:

  default `NULL`. Defines the widget size, passed to
  [`htmlwidgets::createWidget()`](https://rdrr.io/pkg/htmlwidgets/man/createWidget.html).

- element_id:

  default `NULL`. Defines the DOM element id to render into.

## Value

An htmlwidget.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

as_widget(arc_col(df, species, mass))

{"x":{"iLayer":{"id":"arcgisviz-layer","layerType":"ArcGISFeatureLayer","title":"chart_data","featureCollection":{"layers":[{"featureSet":{"spatialReference":{},"features":[{"attributes":{"mass":1.0,"object_id":1.0,"species":"a"}},{"attributes":{"mass":5.0,"object_id":2.0,"species":"b"}},{"attributes":{"mass":3.0,"object_id":3.0,"species":"c"}}]},"layerDefinition":{"name":"chart_data","objectIdField":"object_id","fields":[{"name":"object_id","type":"esriFieldTypeOID","alias":"object_id","length":null,"editable":false,"nullable":false},{"name":"species","type":"esriFieldTypeString","alias":"species","length":null,"editable":true,"nullable":true},{"name":"mass","type":"esriFieldTypeDouble","alias":"mass","length":null,"editable":true,"nullable":true}],"hasAttachments":false,"maxScale":0.0,"minScale":0.0,"type":"Table"},"name":"chart_data","title":"chart_data"}],"showLegend":true}},"chartType":"barChart","config":{"version":"25.1.0","type":"chart","axes":[{"type":"chartAxis","title":{"type":"chartText","content":{"type":"esriTS","text":"species"}}},{"type":"chartAxis","title":{"type":"chartText","content":{"type":"esriTS","text":"mass"}}}],"series":[{"type":"barSeries","y":"mass","id":"series1","name":"series1","query":null,"x":"species"}],"title":null},"tooltip":null},"evals":[],"jsHooks":[]}
```
