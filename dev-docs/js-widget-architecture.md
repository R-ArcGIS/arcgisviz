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
  -> srcjs/widgets/arcgisChart.js (bundled to inst/htmlwidgets/arcgisChart.js)
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
  arcgisChart.js       BUNDLED OUTPUT (generated - do not hand-edit)
  arcgisChart.css      BUNDLED OUTPUT (generated - do not hand-edit)
  arcgisChart.yaml     htmlwidgets dependency declaration (hand-written)
  <hash>.js, <hash>.css  webpack's lazy-loaded vendor chunks (amCharts,
                      pdfmake/xlsx export plugins, etc.) - generated
R/arcgis-chart-widget.R  arcgis_chart(), arcgisChartOutput(), renderArcgisChart()
```

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
`srcjs/widgets/arcgisChart.js` changes - `inst/htmlwidgets/arcgisChart.js`
is generated output, not source, and won't update itself.

The production bundle is large (~3MB main entry + several MB of
lazy-loaded vendor chunks for amCharts4/5 and chart export functionality
via `pdfmake`/`xlsx`/`canvg`). This is inherent to `@arcgis/charts-components`
itself, not something introduced by this build setup.

## Verifying changes

There's no browser automation in this environment, so verification stops
at: webpack build succeeds with no errors, and
`htmlwidgets::saveWidget()` produces valid HTML that correctly references
`arcgisChart.js`/`arcgisChart.css` and embeds the expected `x` payload
(checked by hand once when this was set up - see git history around the
initial scaffold commit). Actual rendering in a browser has not been
visually confirmed and should be checked manually (e.g. open the
`saveWidget()` output, or run inside Shiny/RStudio Viewer) before relying
on this for anything beyond further development.
