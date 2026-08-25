# Maps: `<arcgis-map>` from client side feature collections

Read against `@arcgis/map-components@5.1.19` and `@arcgis/core@5.1.17`.
The render path described here is built (`R/arc-map.R`,
`srcjs/widgets/arcgisMap.js`); the Shiny half is not.

## The route, and the one it replaced

An earlier draft of this document assumed the chart contract ported over
whole: R assembles a JSON document, the browser calls a `fromJSON` on it,
done. For maps that would have meant a **Web Map** document through
`WebMap.fromJSON()`.

That is not the route. Maps build a **client side `FeatureLayer`** directly,
per the SDK's own large-feature-collection sample:

```js
new FeatureLayer({ objectIdField, geometryType, source, spatialReference, renderer })
viewElement.map.add(layer)
```

The consequence that matters: **there is no web map document to model.** The
persistence format is the feature collection layer this package already
builds for charts, and the only spec surface left is the renderer, which
`R/types-renderer.R` already covers. "S7 all the way down" models the
*layer*, not the document.

## What crosses the wire

Every layer, on both widgets, is an **`IFeatureLayer`**
(`rest-js-types.d.ts:1953`), modeled as S7 in `R/types-feature-layer.R` and
built by `as_feature_layer()`. One producer, not one per widget: charts send
it as `WebChart$iLayer` and maps send a list of them.

Nothing about its interior is hand-assembled. `arcgisutils` builds all of it:

| part | built by |
|---|---|
| `featureCollection` | `as_feature_collection(layers = list(as_layer(...)))` |
| `layerDefinition` | `as_layer_definition(..., drawing_info = )` |
| `id`, `popupInfo` | `as_layer(id = , popup_info = )` |

Those bare lists are a documented interface. Pass them through; do not reach
into one to re-assemble its parts.

What the browser reads off it:

| R | browser |
|---|---|
| `featureCollection.layers[0].layerDefinition$objectIdField` | `objectIdField` |
| `...$fields` | `fields`, via `Field.fromJSON` |
| `...$drawingInfo$renderer` | `renderer`, via `renderers/support/jsonUtils.fromJSON` |
| `...featureSet` | `FeatureSet.fromJSON()`, then `.features` -> `source` |
| `opacity`, `visibility` | `opacity`, `visible` |

`FeatureSet.fromJSON()` is doing real work: it turns Esri feature JSON into
`Graphic`s and normalizes `esriGeometryPoint` to the `"point"` that
`FeatureLayer$geometryType` wants. Don't hand-roll either conversion.

`opacity` and `visibility` are layer properties, not `layerDefinition` ones,
and `drawingInfo.renderer` is where a web map feature collection puts its
renderer - so this stays spec-faithful even though nothing calls
`WebMap.fromJSON()`.

## What the element takes

`<arcgis-map>`'s accessors are **live `@arcgis/core` instances** - `map: Map`,
`basemap: Basemap | string`, `graphics: Collection<Graphic>`, `popup: Popup`
(`components/arcgis-map/customElement.d.ts:609` and around). There is no
`config` property. `basemap`, `center`, `zoom` and `extent` autocast from
plain values, which is why those four are all R sends.

`viewOnReady()` gates everything: `mapEl.map` is not there before it
resolves. Layers are added after.

## No bundled spec

`@arcgis/charts-components` ships `dist/spec/*.d.ts` and the
`arcgis-spec-types` skill is built on hand-writing S7 classes from it.
**`@arcgis/map-components` ships nothing equivalent** - `dist/types/` is
framework glue, `dist/support/` is `resources.d.ts`/`slots.d.ts`, no JSON
schema anywhere. Since the route above needs no document spec, that costs
nothing today. It would matter the moment web map documents come back.

## Assets

`@arcgis/core`'s `config.js` already defaults `assetsPath` to
`https://js.arcgis.com/5.1.17/@arcgis/core/assets` when it is empty, so
icons and localization load from Esri's CORS-enabled CDN with no
configuration. `setAssetPath()` from `@arcgis/map-components` does the same
for component assets.

The cost is a network round trip at render time, which is wrong for an
offline Viewer or a locked-down org. Copying assets into
`inst/htmlwidgets/` and calling `setAssetPath()` fixes that at a real size
cost on top of the 2.7MB the map bundle already carries. **Not decided.**

## The 179 components are two different things

- **Containers** (3): `arcgis-map`, `arcgis-scene`, `arcgis-link-chart`.
  These take the document and are what S7 builds.
- **Widgets** (~176): `arcgis-legend`, `arcgis-search`, `arcgis-sketch`,
  `arcgis-layer-list`, `arcgis-time-slider`, the `arcgis-print-*` and
  `arcgis-utility-network-*` families.

The widgets looked like the `{calcite}` problem - `htmltools` tag
constructors plus Shiny input bindings, one file per component - but they are
not. They slot in as children of the container, so **one** `add_widget(map,
"legend", position = "top-right")` covers all of them: the R side is a
registry row, the JS side an `import()` and three property assignments. No
tag constructor, no S7 config. Only the ones with real inputs need event
wiring on top, and that is per component rather than per widget.

## Done since

1. **Shiny.** `arc_map_proxy()` mirrors `arc_proxy()` (`R/arc-map-proxy.R`).
   The layer stays in the factory closure so data does not cross twice, same
   as charts. `goTo()`, `takeScreenshot()` and the `hitTest()`-backed click
   and hover events are wired; `arcgisViewLayerviewCreate` is not.
2. **Hover tooltips.** `add_layer(tooltip =)` builds a `popupInfo` through
   `as_layer(popup_info =)` and the client reads its `fieldInfos`. Click
   popups stay off (`popupEnabled = false`) - see CLAUDE.md's map section.
3. **Selection**, on the view's `SelectionManager` rather than a per-layer
   highlight handle. It is one set across layers with a `selection-change`
   event, so `input$<output_id>$selection` finally exists and a map can drive a
   chart. `set_selection(mode =)`, `add_layer(selectable =)` and
   `arc_draw_selection()` all write to it; `arc_selected()` reads it and
   `set_highlight()` styles it. `SelectionOperation` (5.1) is the SDK's own
   draw-to-select, so rectangle/polygon/lasso/circle/point selection needed
   no sketch wiring of our own.

4. **The widget components**, through one `add_widget()` idiom rather than a
   function per component. Fourteen so far - legend, layer list, basemap
   gallery and toggle, search, bookmarks, zoom, home, compass, fullscreen,
   locate, track, scale bar, coordinate conversion. Each is an explicit
   `import()` so webpack code-splits it; the entry bundle grew 29KB for all
   fourteen. This answers the "`{calcite}` problem" below: the containers
   take config, the widgets take a slot, and a registry is enough.

5. **The tools**: sketch, editor, and the two 2D measurements. These are the
   widgets with something to say, and each says it from a different place -
   sketch from its own events, the editor from the *layer's* `edits` event,
   the measurements from a `reactiveUtils.watch()` on the analysis view's
   result. Geometry returns as an Esri feature set string that `arc_sf()`
   parses, so a drawn polygon is an `sf` object one call later. Client side
   layers turn out to be fully editable (`clientSideDefaults.js` gives them
   add/update/delete and a default template), though the edits live in the
   browser until R decides to keep them.

## Still to do

1. **Click popups**, which are now one flag away but would duplicate the
   hover text until they can show something the tooltip does not.
3. **Layer types beyond feature collections.** `IFeatureLayer` is modeled;
   the image-service, tiled-image-service, and WCS members of
   `WebChart$iLayer`'s union are not, and a layer here always carries a
   client side `featureCollection` rather than a service `url`.
4. **`setDataFilters()`-style persistence.** `set_filter()` writes
   `definitionExpression`, which the layer keeps, but nothing persists a
   filter across a re-render the way the chart's stored config does.

## What I would not do

Model `Graphic`/`Collection`-typed accessors as S7. They are live objects
with no JSON persistence form.
