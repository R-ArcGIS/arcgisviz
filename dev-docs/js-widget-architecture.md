# JS widget architecture

How `arcgisviz` gets a chart from R data onto the screen via
`@arcgis/charts-components`, and what's still deferred.

## Data flow

```
R data.frame / sf object
  -> arcgisutils::as_layer() / as_feature_collection()
       produces a plain list: the IFeatureLayer JSON
       (featureSet + layerDefinition, type: "featureCollection"
       style layer - fully self-contained, no live service needed)
  -> arcgis_chart(i_layer, chart_type, x_field, y_field)
       R/arcgis-chart-widget.R - htmlwidgets::createWidget() wrapper
  -> htmlwidgets serializes x = list(iLayer=, chartType=, xField=, yField=)
       to JSON and embeds it in the page
  -> srcjs/widgets/arcgisChart.js (bundled to inst/htmlwidgets/arcgisChart.module.js)
       renderValue(x):
         const model = await createModel({ iLayer: x.iLayer, chartType: x.chartType })
         await model.setXAxisField(x.xField)
         await model.setYAxisField(x.yField)
         chartEl.layer = model.getLayer()   // live FeatureLayer, built internally by createModel
         chartEl.model = model
  -> <arcgis-chart> custom element renders the chart
```

The key simplification: **no live ArcGIS feature service is required**.
`createModel({ iLayer, chartType })` (from `@arcgis/charts-components`,
`model/shared/setup-utils.js`) accepts the JSON layer definition directly
and builds the client-side `FeatureLayer` internally; we just read it back
via `model.getLayer()` to hand to `<arcgis-chart layer=...>`. This means
`arcgis_chart()` can render any R data.frame/sf object with zero server
round-trips.

## What's deferred

- **Serialization of our S7 config classes.** `WebChart`/`WebChartBarChartSeries`
  (see `R/types-bar-chart.R` etc.) are not yet converted to/from JSON. The
  widget currently only sets `xField`/`yField` via the model's documented
  setters (`bar-chart-model.json`) after creation - it does not pass a full
  `config`. Once `s7x` gains `to_json()`/`from_json()` generics (backed by
  `yyjsonr`), `arcgis_chart()` will accept a `WebChart` object and pass its
  serialized form as `x.config`, and `createModel({ iLayer, config })` will
  be used instead of `{ iLayer, chartType }`.
- **FeatureLayer beyond feature collections.** `WebChart$iLayer` and every
  layer-related model method are still typed `class_any` /
  deliberately unresolved in the type registry (see
  `data-raw/resolve-spec-types.R` `deferred_types`). Only the
  `type: "featureCollection"` shape produced by `arcgisutils::as_layer()`
  is wired up; hosted feature service URLs, portal items, etc. are future
  work.
- **calcite-components.** Not currently defined/registered in the JS
  bundle. `<arcgis-chart>` itself doesn't require it to render; the
  authoring/config UI components (`arcgis-charts-config-*`) do and aren't
  wired in yet.
- **Only bar charts have field-mapping wired through** (`x_field`/`y_field`
  map to `setXAxisField`/`setYAxisField`). Other chart types can already be
  requested via `chart_type`, but no chart-type-specific field setup runs
  for them yet.

## Package layout

```
srcjs/
  config/            entry_points.json, output_path.json, externals.json,
                      misc.json, loaders.json - read by webpack.common.js
  widgets/
    arcgisChart.js    the htmlwidgets JS binding (factory/renderValue/resize)
webpack.common.js     shared webpack config (reads srcjs/config/*.json)
webpack.dev.js        development build (source maps)
webpack.prod.js       production build (minified) - what `bun run production` uses
inst/htmlwidgets/
  arcgisChart.module.js  BUNDLED OUTPUT (generated - do not hand-edit).
                      An ES module: the SDK is imported from js.arcgis.com,
                      not bundled. NOT named arcgisChart.js - see below.
  arcgisChart.yaml     htmlwidgets dependency declaration (hand-written).
                      Declares the script with type="module" and links the
                      CDN's own main.css.
R/arcgis-chart-widget.R  arcgis_chart(), arcgisChartOutput(), renderArcgisChart()
```

There are no vendor chunks and no generated `.css`. Every `@arcgis/*` import
is a webpack external pointing at a pinned `https://js.arcgis.com/5.1/` URL
(`srcjs/config/externals.json`), so the whole directory is four files / 24KB
where bundling the SDK produced 1839 files / 106MB.

The `.module.js` suffix is load-bearing: `htmlwidgets::getDependency()` turns
`inst/htmlwidgets/<name>.js` into a binding dependency and hardcodes its
script tag with no attributes, which cannot load an ES module. Under any other
filename no binding dependency is built and the yaml supplies the tag itself.

This layout mirrors the [packer](https://github.com/JohnCoene/packer)
package's `scaffold_widget()` conventions (same `srcjs/config/*.json` +
`webpack.common/dev/prod.js` structure), but the `packer` R package itself
is **not** a dependency here and its scaffold function was not run: packer's
own install/bundle helpers (`engine_init()`, `core_deps_install()`,
`bundle()`) are hardcoded to shell out to `npm` or `yarn`, and this project
uses `bun` for JS package management (there was already a `bun.lock` with
real installed dependencies before this scaffold was added). The directory
structure and webpack config content were copied from packer's templates
by hand instead.

## Build commands

Use the `justfile` recipes (this project's standard command-runner
interface, used for R fmt/lint/test too) rather than calling `bun run`
directly:

```sh
just js-install  # bun install - sync JS deps from package.json + bun.lock
just bundle-dev  # bun run development - webpack --config webpack.dev.js (source maps, unminified)
just bundle      # bun run production - webpack --config webpack.prod.js (minified) - run before a release
just watch       # bun run watch - webpack --config webpack.dev.js -d --watch
```

Re-run `just bundle` (or `just bundle-dev` while iterating) any time
`srcjs/widgets/arcgisChart.js` changes -
`inst/htmlwidgets/arcgisChart.module.js` is generated output, not source, and
won't update itself.

The bundles are small - 3.4KB for the chart, 11KB for the map - because they
contain only this package's own code. `pdfmake`/`xlsx`/`canvg` and the
amCharts engines are `@arcgis/charts-components`' own lazy chunks and are
served from js.arcgis.com, so they cost nothing at install time and are
fetched only if a reader actually opens the chart's export menu.

## Verifying changes

There's no browser automation in this environment, so verification stops
at: webpack build succeeds with no errors, and
`htmlwidgets::saveWidget()` produces valid HTML that references
`arcgisChart.module.js` **with `type="module"`**, links the CDN stylesheet,
and embeds the expected `x` payload.

Since the move to the CDN, three things can only be confirmed in a real
browser and have **not** been:

1. The module script executes before htmlwidgets scans for bindings. Module
   scripts are deferred, so `HTMLWidgets.widget()` registers later than it
   did as a classic script - it should still land before `DOMContentLoaded`,
   but that is reasoning, not evidence.
2. `customElements.whenDefined()` resolves for every map widget, i.e. the CDN
   build really does register all of them up front.
3. The CDN's `main.css` covers what the previously-bundled `arcgisMap.css`
   (50KB of component styling) covered.
