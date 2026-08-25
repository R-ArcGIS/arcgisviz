---
name: arcgis-map-widget
description: Use when touching R/arc-map.R, R/arc-map-proxy.R, R/arcgis-map-widget.R, srcjs/widgets/arcgisMap.js, or anything about drawing an sf object on <arcgis-map> - layers, renderers, hover tooltips, the map Shiny proxy, or the S7 classes behind them. Maps have no bundled .d.ts spec, so their types come from the Web Map Specification - arcgisutils is an S3 reference to check behavior against, not an authority to route through. Load this before adding a map feature or a map S7 class.
---

# ArcGIS maps -> S7 -> `<arcgis-map>`

Maps share this package's renderer and palette code with charts and almost
nothing else. **Do not reason about maps by analogy to charts** - the two
halves that look the same (a layer, a renderer) are the same, and everything
else differs. Full writeup: `dev-docs/map-components-plan.md`.

`inst/htmlwidgets/arcgisMap.js` and `arcgisMap.css` are **generated output**.
The source is `srcjs/widgets/arcgisMap.js`. Build with `just bundle` (or
`bundle-dev`); `load_all()` does not rebuild JS. See the `arcgis-js-widget`
skill for the build system, which both widgets share.

## There is no bundled spec for maps

`@arcgis/charts-components` ships `dist/spec/*.d.ts`, and the
`arcgis-spec-types` skill is built on hand-writing S7 classes from it.
**`@arcgis/map-components` ships nothing equivalent** - `dist/types/` is
framework glue, `dist/support/` is `resources.d.ts`/`slots.d.ts`, and there
is no JSON schema anywhere. So when you need a map type:

| what | where it comes from |
|---|---|
| the layer (`IFeatureLayer`) | `rest-js-types.d.ts:1953`, already modeled in `R/types-feature-layer.R` |
| renderers | the **web map** specification - not the charts spec (`IDrawingInfo$renderer` is `any`), not the web *scene* spec (its renderers are `Symbol3D`, SceneView only), and **not `@arcgis/core`** where the two disagree |
| `layerDefinition`, `featureCollection`, `popupInfo` | the web map spec - currently bare lists from `arcgisutils`, not yet modeled |
| element accessors | `node_modules/@arcgis/map-components/dist/components/arcgis-map/customElement.d.ts` |

`WebMap.fromJSON()` is **not** called and the Web Map Specification is not
modeled as a document. The persistence format is the feature collection
layer, so there is no document spec to write. "S7 all the way down" models
the *layer*, not the document.

## arcgisutils is a reference, not an authority

It is the **S3 implementation of the same problem** this package solves with
S7, and the S7 machinery here is the direction of travel - these types
migrate *into* arcgisutils later. So don't reflexively route everything
through it, and don't treat a bare list it returns as the final shape for
anything. `class_any` on `featureCollection`/`layerDefinition` records that
they are not modeled *yet*, not that they belong to someone else.

Where it earns its keep:

- **Checking behavior.** An S7 analogue has to agree with it. `as_fields()`
  (`infer_esri_type()` is deprecated as of 0.4.0) decides the
  `esriFieldType*` for a column, `ptype_tbl()`/`fields_as_ptype_df()` go the
  other way, and `is_date()`/`date_to_ms()`/`from_esri_date()` own dates.
  The repo is cloned at `../arcgisutils` - read the implementation, not just
  the docs. Index: <https://r.esri.com/arcgisutils/llms.txt>.
- **Not re-deriving what already works.** `as_layer()`,
  `as_layer_definition()` and `as_feature_collection()` take the arguments
  you would otherwise patch in by hand (`drawing_info`, `layer_definition`,
  `id`, `popup_info`), so use those rather than reaching into a returned
  list to re-assemble its parts. `as_feature_layer()` (`R/arc-data.R`) is
  the single producer of a layer for both widgets.

Calling one of those is a convenience while the S7 equivalent doesn't exist.
Writing that equivalent is not off-limits - it is the plan.

Two gotchas that are arcgisutils behavior, not ours: `as_layer()` invents an
`object_id` column (`1:nrow(x)`) when one is absent, which is what map object
ids mean; and a `logical` column has no `vec_mapping` entry, so `as_fields()`
errors on one.

## The element takes live objects, not a config

`<arcgis-map>`'s accessors are live `@arcgis/core` instances - `map: Map`,
`basemap: Basemap | string`, `graphics: Collection<Graphic>`. **There is no
`config` property and no `createModel()` equivalent**, so none of the chart's
`deepMerge`-over-defaults machinery applies. R sends `basemap`/`center`/
`zoom`/`extent` (all four autocast) plus a list of layers, and the JS builds
each `FeatureLayer` itself.

`viewOnReady()` gates everything - `mapEl.map` is not there before it
resolves, so layers are added after.

Two SDK converters do the real work and neither should be hand-rolled:
`FeatureSet.fromJSON()` (Esri feature JSON -> `Graphic`s, and
`esriGeometryPoint` -> the `"point"` `geometryType` wants) and
`renderers/support/jsonUtils.fromJSON()`.

`opacity` and `visibility` are properties of the layer itself, not of the
`layerDefinition` - and `visibility`, not `visible`, is the spec's name
(`ILayer`, `rest-js-types.d.ts:1324`).

**The web map spec and `@arcgis/core` genuinely diverge**, so check the spec
before trusting a `.d.ts`. Worked example: `legendOptions` is *one* shared
object with seven properties in the spec, referenced by ten parents, but
core splits it into `VisualVariableLegendOptions` + `SizeVariableLegendOptions`.
`ILegendOptions` follows the spec. The full typing rules - when `class_any`
becomes a class, pruning by renderer family, discriminator defaults, and the
`new_*()` constructors - are under "Typing a property" in `CLAUDE.md`.

## Renderers: simpler than charts

**A map renderer resolves per feature against the layer**, so the
`uniqueValue` branch charts can only reach while aggregating is always
available. `map_renderer()` is therefore simpler than `color_renderer()`:
numeric -> `continuous_renderer()` (shared verbatim), anything else ->
`unique_value_renderer()`. No `arcgisviz_color` code column, none of the
amCharts5 workaround.

`geometry_symbol_map` is the map's answer to `chart_type_map`'s `symbol_*`
entries - **the geometry decides the symbol**, not the chart type.
`add_layer(color =)` takes a bare column; a *fixed* colour is `palette` with
no `color`, since a map layer has one symbol either way.

## Hover tooltips are `popupInfo`

`add_layer(tooltip = c(County = NAME, Births = BIR74))` - bare column names
in `c()`, a name becomes the label, a bare column labels itself.

The fields ride as **`popupInfo`**, the web map spec's own name for a
labelled field list, written through `as_layer(popup_info =)` where it lands
beside `featureSet` and `layerDefinition`. Nothing here invents a shape. The
client builds a real `PopupTemplate` from it for its `fieldInfos`, then sets
`popupEnabled = false`: the template exists to be read, not to open a popup
repeating what the hover already says.

Hovering is `arcgisViewPointerMove` -> `hitTest({ include: })`, wrapped in
`promiseUtils.debounce()` because the pointer outruns the hit test.
Superseded calls reject with `AbortError` and **must be swallowed**.

**Format a tooltip value by its field type, not its JS type.**
`esriFieldTypeDate` is milliseconds from the epoch
(`arcgisutils::date_to_ms()`), with `-1` for NA (`from_esri_date()`), so a
date read off `graphic.attributes` is a 13-digit number. The JS reads
`layer.fields[].type` - `Field.fromJSON` maps `esriFieldTypeDate` -> `"date"`
(`@arcgis/core/layers/support/fieldType.js`) - and branches on that.

## The Shiny proxy

**`ArcMapProxy` subclasses `ArcMap`**, the same trick as `ArcProxy`:
`set_basemap()`, `set_view()` and `add_layer()` assign a property and return
the object, so all three work on a proxy with zero duplicated code, and
`arc_update()` flushes them as one message.

`arc_update()`, `set_filter()` and `set_selection()` are **S7 generics shared
with the chart proxy**. A method on `S7::class_any` gives the friendly "must
be an ArcProxy or ArcMapProxy" error instead of S7's own "can't find method".
Map-only: `set_layer()`, `remove_layer()`, `arc_goto()`, `arc_screenshot()`.

**A proxy layer must be named**, because the name *is* the layer id
(`map_layer_id()`). An unnamed layer is only positionally unique and would
collide with the rendered map's own `arcgisviz-layer-<i>`. Re-adding a name
already on the map replaces it, which is what makes `add_layer()` idempotent
across flushes and gives `set_layer()`/`remove_layer()` a handle.

**Serialize proxy payloads yourself.** `map_send()` runs `widget_json()` and
sends the result as a *string* the client `JSON.parse`s. Shiny would use
jsonlite, which sends `layerDefinition$fields` columnar and breaks
`Field.fromJSON` - the same trap `TOJSON_FUNC` avoids on the render path.

Protocol mirrors the chart's: one handler, `"arcgisviz-map"`, with a `method`
discriminator - `update`, `remove`, `layer`, `filter`, `select`, `selectBy`,
`goto`, `screenshot`. The layer stays in the factory closure, so **the data
never crosses the wire twice**.

## Selection is the view's SelectionManager

`mapEl.selectionManager` (`@arcgis/core` 5.0, `@beta`) owns a selection set
across layers, highlights it, and emits `selection-change`. Three routes write
to the same set - `set_selection(mode =)`, a click on a `selectable = TRUE`
layer, and `arc_select()`'s `SelectionOperation` (the SDK's own
draw-to-select) - and all three report through `input$<id>_selection`, which
`arc_selected()` reads.

The manager only selects in layers that are its `sources`, so `syncSources()`
runs after every add or remove. A selection identifier is an object id *or* a
`Graphic` depending on the layer (`views/selection/types.d.ts:78`), so the
payload normalizes through `objectIdField`.

`set_highlight()` writes the view's *named* `"default"` highlight options -
`mapEl.highlights` is a collection keyed by name, and any highlight that does
not ask for another one reads that entry. A lasso is the `polygon` create tool
in `"freehand"` mode (`views/draw/types.d.ts:20`); the other four tools send
no mode.

`set_filter()` is the layer's `definitionExpression`. Events become
`input$<id>_click`/`_hover`/`_view`/`_selection`/
`_screenshot`, plus `_error` carrying a `kind` - including `"proxy"`, which a
failing proxy message reports itself rather than dying in the console.

**Every proxy message awaits `whenReady()`** (the memoized `viewOnReady()`
promise): an observer firing on app start reaches the widget before
`renderValue()` is done, and `mapEl.map` is undefined until the view resolves.

Three rules keep the event stream sane: `_hover` fires only when the feature
under the pointer *changes*, `_view` is debounced 250ms because
`arcgisViewChange` fires throughout an animation, and `subscribeEvents()` is
guarded by `state.subscribed` because `renderValue()` runs again on every
re-render.

## Verifying a change (no browser available here)

Same ceiling as the chart widget - there is no browser automation, so this
confirms the R -> JSON -> htmlwidget pipeline and that webpack produced
loadable JS, **not** that the map draws correctly.

```r
devtools::load_all(quiet = TRUE)
nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
w <- as_widget(add_layer(arc_map(), nc, color = BIR74, tooltip = NAME))
htmlwidgets::saveWidget(w, tempfile(fileext = ".html"), selfcontained = FALSE)
```

`tests/testthat/test-map.R` asserts the serialized layer shape and
`test-map-proxy.R` the message payloads; both read what the browser reads,
not the R objects. For a proxy, pass a fake session capturing
`sendCustomMessage()` and parse the payload string with
`yyjsonr::opts_read_json(arr_of_objs_to_df = FALSE)` - simplifying arrays to
a data frame hides the shape the client actually receives.

## Deferred (don't "fix" without asking)

- **Click popups**, one flag away but redundant with the hover text until
  they show something it does not.
- **A legend** (`arcgis-legend` slotted in) and the ~176 other widget
  components - the `{calcite}` problem, see the plan doc.
- **Non-feature layer types** - a layer here always carries a client side
  `featureCollection`, never a service `url`.
- **Offline assets.** `@arcgis/core`'s `config.js` defaults `assetsPath` to
  the Esri CDN, so nothing configures it. Offline would need assets in
  `inst/htmlwidgets/` plus `setAssetPath()`. Not decided.
- **Modeling `Graphic`/`Collection`-typed accessors as S7.** They are live
  objects with no JSON persistence form.
