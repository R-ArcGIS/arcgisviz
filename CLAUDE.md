# arcgisviz

An R package binding to the ArcGIS Maps SDK Charts capabilities
(`@arcgis/charts-components`). Two halves: an S7 type layer in R that
mirrors the JS chart config JSON shape, and an htmlwidget that renders
`<arcgis-chart>` in the browser from that config plus a data source.

**Source of truth for types is `@arcgis/charts-components`'s own bundled
spec**, not a separate package. `@arcgis/charts-model`/`@arcgis/charts-spec`
(the packages this project originally generated types from) are on an
independent, stalled version line (`4.32.15`, the latest published, with no
newer release) that has diverged from what `@arcgis/charts-components`
(tracking SDK `5.1.x`) actually ships and runs - confirmed by real
divergence (`subTitle` renamed to `subtitle`, `WebChartScatterPlotSeries`
renamed to `WebChartScatterplotSeries`, temporal binning restructured, etc).
Both packages were removed from `package.json`/`node_modules` for this
reason. Read types from:
- `node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts` - the
  WebChart config shape (all `WebChart*`/series/axis/query interfaces, one
  file).
- `.../dist/spec/chart-object-literals.d.ts` - `WebChart*` enums (as const
  objects + derived types).
- `.../dist/spec/rest-js-types.d.ts` - `Color`, `IFont`, `ISimpleFillSymbol`/
  `ISimpleLineSymbol`/`ISimpleMarkerSymbol`/`ITextSymbol`,
  `IStatisticDefinition`.
- `.../dist/spec/rest-js-object-literals.d.ts` - `RESTUnits` and REST-prefixed
  symbol-style consts (mostly unused directly - the non-REST-prefixed
  versions in rest-js-types.d.ts are what properties actually reference).
- `.../dist/spec/data-source.d.ts` - `TimeIntervalInfo`, `RGBObject`.

**Don't hand-write types from a JSON Schema.** There is one in the dist
(`dist/chunks/index4.js:14` holds a draft-07 object with a full `definitions`
block, and `dist/json-schema/index.d.ts` types that object's shape), but the
`.d.ts` files above are the readable source and stay authoritative - the
schema carries no type detail the declarations lack, and its own
`IDrawingInfo$renderer` is untyped. `data-raw/resolve-spec-types.R` and
`data-raw/spec-type-registry.json` (the old JSON-Schema-driven pipeline) are
**stale/archival** - don't treat them as current, and don't mechanically
regenerate `R/types-*.R`/`R/enums-*.R` from them. Types are now hand-written
directly against the `.d.ts` files above, same as the imperative-API
`data-raw/<model>.json` docs always were (those are separately stale too -
they came from the removed `@arcgis/charts-model` package's method-level
`.d.ts` files, describing the `createModel()`/JS-wiring path, which is not
current work - see `arcgis-js-widget` skill).

## Commands

Use `just` (see `justfile`), not raw `Rscript`/`bun` calls:

```sh
just fmt          # air format R/ + tests/
just lint         # jarl check + air format --check
just test         # devtools::test()
just js-install   # bun install
just bundle-dev   # rebuild the JS widget bundle (dev, unminified)
just bundle       # rebuild the JS widget bundle (production, minified)
just watch        # rebuild JS on every srcjs/ change
```

## Every new feature needs a `dev/` example

Every user-facing feature gets a `dev/` example (one file per feature,
`dev/set-labs.R`), rendered in the Viewer and using `datasets::penguins`.
These become user-facing tutorials later, so write them to be read.

## Three skills, load them for the relevant work

- **`arcgis-spec-types`** - hand-writing `s7x`-based S7 classes in `R/`
  directly from `@arcgis/charts-components`'s bundled `.d.ts` spec (see
  above - no JSON Schema, no mechanical resolver anymore). Load this before
  adding a new chart type or touching any `R/types-*.R` / `R/enums-*.R` /
  `R/color.R` file.
- **`arcgis-js-widget`** - the htmlwidget: `srcjs/`, webpack config,
  `R/arcgis-chart-widget.R`, the `createModel`/`<arcgis-chart>` contract.
  Load this before touching anything JS-side or the R widget wrapper.
- **`arcgis-map-widget`** - the *other* widget: `R/arc-map.R`,
  `R/arc-map-proxy.R`, `srcjs/widgets/arcgisMap.js`, and the S7 classes
  behind them. Maps have **no bundled spec**, so their types come from the
  Web Map Specification and arcgisutils' builders rather than a `.d.ts` -
  which is why this is its own skill and not a section of the other two.
  Load it before adding a map feature or a map S7 class.

The skills point to more detail: `dev-docs/js-widget-architecture.md` for the
full JS/data-flow writeup, `dev-docs/map-components-plan.md` for the map one.

## Current state, in one paragraph

Bar chart, scatterplot, and line chart (incl. combo bar-line, which needs
zero new code since `WebChart$series` is an untyped `class_list`) have
complete S7 type stacks (config classes + enums), rebuilt against
`@arcgis/charts-components`'s bundled spec (see above) and verified to
construct end-to-end with realistic, minimally-specified data (see
`tests/testthat/test-type-defaults.R`). On top of that sits a public API
that exposes no S7 objects (`R/arc-chart.R`: `arc_chart() |> set_type() |>
set_x() |> set_y()`, plus `arc_bar()`/`arc_scatter()`/`arc_line()` sugar,
tidy-eval bare column names, friendly kebab-case type names) and a data
-transfer layer (`R/arc-data.R`) that turns a data frame + config into the
widget payload. That public API now covers mapping (`set_x()`/`set_y()`/
`set_stat()`), text (`set_labs()`), colour and grouping (`set_color()`, see
below), marker size (`set_size()`), hover text (`set_tooltip()`), and scales
(`set_axis()`/`set_flipped()`/`set_position()`). Six chart types are modeled:
bar, line, scatter, histogram, box plot, and heat (plus combo bar-line for
free). Pie, gauge, and radar are not. On top of that sits a Shiny layer
(`R/arc-proxy.R`): `arc_proxy()` returns an `ArcChart` subclass, so every
`set_*()` works on a rendered chart, and `arc_update()` flushes. `set_legend()`
exists on the proxy only - `WebChart$legend` is still modeled-but-unset on
the `ArcChart` side, which grouped charts make worth closing. Alongside all of
that, and sharing its renderer and palette code but almost nothing else, sits
a second widget: `arc_map() |> add_layer()` draws an `sf` object on
`<arcgis-map>` as a client side feature layer (`R/arc-map.R`,
`srcjs/widgets/arcgisMap.js`), with hover tooltips (`add_layer(tooltip =)`)
and its own Shiny proxy (`R/arc-map-proxy.R`).

Two shapes worth knowing before adding a seventh chart type. `chart_type_map`
(`R/arc-chart.R`) carries `config_class`, `has_y`, `aggregates`,
`tooltip_fields`, `splits`, `stacks`, and `sizes` per type, and
`build_webchart()` reads them rather than branching on the type name.
Chart types whose spec defines a `WebChart` subtype get it as a real S7
subclass (`WebBoxPlot`, `WebHeatChart`), which is how they inherit the
`as_vector()` method that drops unset properties. And **every axis must carry
`type = "chartAxis"`**: `deepMerge()` maps over the source array
(`srcjs/widgets/arcgisChart.js:24`), so an axis that compacts away to nothing
shortens `axes` and deletes one of the model's own.

Options that belong to one chart type get a `set_<type>()` function
(`set_histogram()`, `set_boxplot()`) whose arguments are also arguments on the
`arc_<type>()` shortcut, both documented in one Rd via `@rdname`. Not one
exported function per property - that contradicts `set_axis()` and doesn't
scale. They land in `ArcChart@series_opts`/`@config_opts` (already keyed by
spec property name) and are spliced in by `build_webchart()`; `merge_opts()`
makes repeated calls layer rather than reset, the same rule as `set_labs()`.

## Serialization

`s7x::to_json(x, ..., pretty = FALSE)` works for any S7 config class in this
package - it's `as_vector(x)` + `yyjsonr::write_json_str(auto_unbox = TRUE)`,
a generic `S7_object` method in `s7x`.

**`as_vector()` is the single extension point for the wire format**, and
`widget_json()` is the single place it is called. Nothing flattens at a call
site: an `ArcChart`'s `@webchart` and an `IFeatureLayer` travel as their own
classes right into the payload, and the serializer converts the lot. It
recurses through the generic (`as_vector_value()`, `s7x/R/as_vector.R`), so a
method on a nested class fires during the parent's walk. `R/arc-data.R`
registers these, and `to_json()` inherits all of them for free:

- `WebChart` - drops unset (NA/NULL) properties via `compact_config()`.
- `IFeatureLayer` - drops unset properties **shallowly**. A deep walk would
  visit every feature, and everything nested under it comes from arcgisutils
  already well-formed.
- `ISimpleRenderer`/`IUniqueValueRenderer` - compact, because on a map a
  renderer sits in `layerDefinition$drawingInfo` where no parent compacts it.
- the three `WebChart*Series` classes - emit `query: null` when the query is
  unset, the client-side signal to delete a default.
- `Color` - the spec's raw `[r,g,b,a]` tuple, undoing this package's
  deliberate r/g/b/a exception. A partly-specified color returns `NULL` and
  drops out.
- `WebChartScatterplotSeries` also returns `additionalTooltipFields` as a
  list. `auto_unbox = TRUE` would send a one-element `class_character` as a
  bare string, and the client spreads that value into the query's `outFields`
  (`fu()`, `dist/chunks/index2.js:7857`) - a string spreads to its own
  characters. **Any spec property typed `string[]` needs this**, whatever
  the R property's type.

Two mechanics this depends on: `S7::super(x, S7::S7_object)` to reach the
default method from an override (otherwise infinite recursion), and
`.onLoad()`'s `S7::methods_register()` in `R/zzz.R` - without it, methods on
another package's generic are registered at build time and lost on install.
`S7::method(s7x::as_vector, X) <- f` does *not* work (the replacement form
would assign back through `::`), hence the `@importFrom s7x as_vector`.

`from_json()` (JSON -> S7 object) doesn't exist yet - harder problem, needs
to know which class to construct into.

## Data transfer (R -> browser)

`R/arc-data.R` builds the `createModel()` payload; its header comment cites
the exact `@arcgis/charts-components` dist files/functions each rule comes
from, and `tests/testthat/test-data-transfer.R` asserts the shapes. The
non-obvious parts:

- `createModel()` is called **twice**, and R sends both `chartType` and
  `config`. A sparse config can't go to `createModel()` alone - a `WebChart`
  needs a full axes/labels/symbol tree or the engine throws "There are no X
  axes on chart" - and `getDefault*Chart()` needs a `CommonStrings`
  localization bundle we can't construct. So: `createModel({ iLayer,
  chartType })` harvests the model's own defaults, `deepMerge()` layers R's
  sparse config over `defaults.config`, then `createModel({ iLayer, config })`
  builds the real model from the complete config. Assigning `model.config`
  post-setup instead re-adds series before axes and fails.
- `deepMerge()` treats **`null` as delete**, not as a value. It's R's only
  way to unset one of the model's defaults, since an absent key just leaves
  the default in place. `stat = "identity"` needs it: the default bar/line
  series ships a count aggregation (`$e()`, `dist/chunks/index.js`) and
  `BarAndLineNoAggregation` requires `query.outStatistics` to be `undefined`
  (`ga()`, `dist/chunks/index2.js:593`).
- **Aggregation is `stat`, and it maps 1:1 onto ggplot2's.** `ga()` picks the
  bar/line subtype purely from the query shape: no `outStatistics` ->
  `BarAndLineNoAggregation` (`geom_col()`, `stat = "identity"`);
  `groupByFieldsForStatistics` + `outStatistics` -> `BarAndLineMonoField`
  (`geom_bar()`/`stat_summary()`). Under aggregation the series' `y` must
  name the `outStatisticFieldName`, not the source column - which is why
  `ArcChart` holds the *mapping* (`x`/`y`/`stat`) and `@webchart` is a
  computed getter (`build_webchart()`), not a stored, eagerly-mutated object.
- `iLayer` needs `layerType = "ArcGISFeatureLayer"` and carries the data at
  `featureCollection$layers[[1]]$featureSet` / `$layerDefinition`. The
  converter (`gi`, `dist/chunks/index2.js`) reads *only* those paths plus
  `fields`/`objectIdField`/`geometryType`/`spatialReference` - which is
  precisely what `arcgisutils::as_feature_collection()` emits.
- Unset properties must be **dropped**, not sent as JSON `null` - the
  default `as_vector()` method materializes every property (16 of
  `WebChart`'s 20 top-level ones are NA/NULL for a minimal chart), and an
  explicit null would override a default instead of falling back to it. See
  "Serialization" above: this and the `Color` tuple conversion are both
  `as_vector()` methods, not a bespoke pass.
- **We serialize the widget payload ourselves.** The widget sets
  `attr(x, "TOJSON_FUNC") <- widget_json`, htmlwidgets' documented hook for
  replacing its serializer outright, so nothing depends on
  htmlwidgets'/jsonlite's defaults. `widget_json()` is yyjsonr-based (same
  engine as `s7x::to_json()`), and yyjsonr's defaults are the correct ones
  here where jsonlite's are not: `dataframe = "rows"` (jsonlite defaults to
  "columns", which silently breaks `layerDefinition$fields` - the JS does
  `fields.map(Field.fromJSON)` and needs an array of objects) and
  `str_specials`/`num_specials = "null"` for NA. Prefer our own
  serialization over a host package's wherever the option exists.
  htmlwidgets hands the function the whole payload (`x`, `evals`,
  `jsHooks`), not just `x`, and expects a JSON string back.
- Single-shot only: the whole collection goes over in one payload.
  `arcgisutils::as_esri_features()` is the per-feature JSON a future
  batched path would stream (cf. the SDK's large-collection sample, which
  does that via `applyEdits()` on a *live* layer), but nothing needs it yet.

## Colour (`set_color()`), and the two mechanisms it needs

Colour goes over as `WebChart$chartRenderer` + `colorMatch = TRUE`. The client
hands that renderer to `@arcgis/core`'s `jsonUtils.fromJSON()` and resolves a
symbol **per data item** via `symbolUtils.getDisplayedSymbol()`
(`dist/chunks/index2.js:1541`, `:1612`), so no multi-series split-by is
involved. The renderer classes are hand-written from the **web map**
specification, not the charts spec (`IDrawingInfo$renderer` is `any`) and not
the web *scene* spec (its renderers reference `Symbol3D`, SceneView only).

Which renderer to send is decided by the **query shape, not the chart type**,
and both branches were established empirically:

- **Not aggregating** - a `simple` renderer carrying a `colorInfo` visual
  variable. Continuous colour spreads the ramp's own stops across
  `range(column)` and lets the client interpolate. *Categorical* colour uses
  the same mechanism, because a `uniqueValue` renderer is silently ignored on
  the scatter (amCharts5) path: `chart_data()` appends an
  `arcgisviz_color` integer-code column and the VV gets one stop per code, so
  no value ever falls between stops and interpolation never kicks in. Stop
  `label`s carry the level names.
- **Aggregating** - a `uniqueValue` renderer on the grouped column. A derived
  code column can't work here because the query returns only
  `groupByFieldsForStatistics` plus the statistics. For the same reason, a
  *numeric* colour column while aggregating is an error, not a silent no-op -
  it can only be a gradient, so it can't become a group either.

**Heat charts are the exception**: cells are shaded by the series' own
`gradientRules`/`classBreaksRules`, not by `chartRenderer`, and the value is
the cell count so there is no column to map. `set_color(chart, palette =)`
takes `palette` alone. An Esri ramp travels by *name* in
`classBreaksRules$colorRampInfo` and the client generates the class breaks
itself (`serial-chart-data.js:487`, and `generateHeatChartClassBreaks()` at
`customElement.js:18668`, which runs for heat and nothing else). Any other
palette collapses to the two-colour `gradientRules$colorList` the spec allows.
Ramps tagged `heatmap` in `esri_color_ramps` are the ones built for this.

**Colouring by a column other than `x` groups the chart**, on the types that
support it. Dodging and stacking need *multiple series* - `stackedType` is
documented as "how the bars/lines should be placed when multiple series are
rendered" - and the client decides a chart is split purely from the **`where`
clause on each series' query**, not from the chart type: `ga()`
(`dist/chunks/index2.js:593`) returns `BarAndLineSplitBy` when `where` is a
real filter alongside `outStatistics`, and `BarAndLineSplitByNoAggregation`
when there is no `outStatistics`. So `chart_split()` emits one series per
level, each with `where = "col='level'"` (single quotes doubled, mirroring
`normalizeWhereClause()`), a unique `id`, and `name = level` for the legend.

**The `where` clauses never actually run.** Having read them, the client
builds *one* query grouped by `[x, splitField]` (`os()`, `index2.js:1816`)
and reshapes that single result, keying each series' values by its own
statistic output field - which `ns()` (`:1793`) takes verbatim from
`outStatisticFieldName` when it is set. So every split series needs a
**distinct** `outStatisticFieldName`, and its `y` must equal it. Sharing one
name makes all series read the same column and draw identical bars, which
looks like the filter being ignored. Hence `series_aggregation(suffix =)`:
`_0` unsplit (the SDK's own convention), `_<level>` per split series.

**Splitting and stacking are two different capabilities and two different
sets of chart types.** Don't conflate them.

*Splitting* (`chart_type_map$splits`) works for **bar, line, combo, and box
plot** - the only types with split-by subtypes
(`utils/misc/interfaces.d.ts:7`). Scatter reads `series[0]` and ignores the
rest, so it and histogram and heat keep colouring per item through
`chartRenderer`. A grouped box plot is `BoxPlotMonoFieldAndCategoryAndSplitBy`
(`xn()`, `index2.js:600`).

*Stacking* (`chart_type_map$stacks`) works for **bar and line only**, as the
spec's own note on `stackedType` says (`web-chart.d.ts:1307`). This is
verifiable rather than a matter of trust: the entire bundle sets amCharts
stacking in exactly four places, three inside `Gr()`
(`customElement.js:13342`) and one inside `G0()` (`:15392`), and `Zr()`
(`:16839`) - the series-builder dispatcher - routes to `G0` for `BarSeries`
alone, sending histogram to `rL`, heat to `ev`, and box plot to `bF`. **So
`position =` for histogram and heat is not a missing feature, it is
unimplementable client-side**, and a box plot arranges its own groups side by
side. `set_position()` errors on all three rather than silently no-opping,
and `chart_position()` sends no `stackedType` at all for them.

A split series carries its colour on **its own symbol** (`fillSymbol` /
`lineSymbol`, per `chart_type_map$symbol_property`) and the chart sends no
`chartRenderer` at all. A `uniqueValue` renderer would also work - the client
honours one when `renderer.field` equals the split field (`index2.js:1405`) -
but the symbol path is what `colorMatch = false` documents ("the colors from
the config, and then from the color ramps will be used"), and it doesn't
depend on that match holding.

`set_position()` / the `position` argument on `arc_bar()`/`arc_col()`/
`arc_line()` map ggplot2's `dodge`/`stack`/`fill` onto
`sideBySide`/`stacked`/`stacked100`. A split chart defaults to `dodge`; an
unsplit one sends no `stackedType` at all.

`set_size()` maps a numeric column onto marker area, the bubble-chart
variant of a scatterplot. `sizePolicy` is declared on
`WebChartScatterplotSeries` alone (`web-chart.d.ts:843`), so no other type
takes it, and `chart_type_map$sizes` gates it.

A colour mapping is otherwise unreadable on hover, so the coloured-by column
also goes into `series$additionalTooltipFields`. That property exists **only
on the scatterplot series** (`web-chart.d.ts:845`) - the shared
`WebChartSeries` has `dataTooltip*` formatting and nothing that names a field
- so bar, line, histogram, box, and heat tooltips still show only x and y.
`tooltipFormatter` would cover them but it's a JS callback on the component,
not config JSON, so it can't travel from R.

Palettes live in `R/sysdata.rda`, built by `data-raw/color-palettes.R` from
`@arcgis/core/smartMapping/symbology/support/colors.js`: 521 ramps (name, tags,
stops), plus `esri_series_palette` (ColorBrewer Paired-10, the SDK's own series
palette at `chunks/index.js:45`) and `esri_default_ramp` (`"Blue 3"`, its
`defaultColorRampForCharts` at `chunks/class-breaks.js:475`). `palette` also
takes any vector of R colours, parsed by `grDevices::col2rgb()` in `R/color.R`.

`R/palettes.R` turns that catalogue into the user-facing `esri_palettes()`,
one row per ramp, filterable by `type`/`color_mode`/`hue`/`tag`. Two facts
about the tag vocabulary hold across all 521 and are what let those be scalar
columns rather than list ones: every ramp carries **exactly one** of
`light`/`dark`, and **at most one** of `sequential`/`diverging`/`categorical`
(118 carry none - the `centered-on`, `extremes`, and `heatmap` families).
`palette_tags()` is the full vocabulary. It builds the frame with
`arcgisutils::data_frame()`, which adds a `tbl` class for printing without
pulling in tibble.

## Tooltips (`set_tooltip()`), and why they take two paths

`set_tooltip(\`Body mass\` = body_mass)` takes named arguments: the name is
the label, a bare column labels itself.

**Labels ride as field aliases, not as a popupTemplate.** `_e()`
(`chunks/index3.js:646`) returns a field's `alias` and falls back to its
name, and `Ce()` (`index2.js:3331`) reads `layerDefinition.fields[].alias`
unconditionally for a feature layer. So `tooltip_aliased()` just rewrites the
alias in the layer we already build. `popupTemplate.fieldInfos[].label` +
`popupTemplateFieldInfosEnabled` also works and *overrides* the alias, but
needs an element flag for no gain. An alias also titles axes and legend
entries, which is a feature, not a leak.

**`additionalTooltipFields` is scatter-only** (`web-chart.d.ts:845`) and is
the only field-naming tooltip property in the whole spec. Everything else
goes through `tooltipFormatter`, which we can set because we own the bundle.
Its per-type signatures decide what is possible:

| type | formatter args | key |
|---|---|---|
| scatter | `(x, y, size, dataContext)` | native path used instead |
| bar/line/combo | `{seriesName, statValue, xValue, ...}` | seriesName + x |
| heat | `(value, xValue, yValue)` | x + y |
| box plot | `{seriesName, dataContext, xValue}` | seriesName + x |
| histogram | `(count, binMin, binMax)` | **none** |

Heat honours a formatter (`Qx()`/`Jx()`, `customElement.js:10740`) even though
`TooltipFormatters` doesn't list a heat variant - don't trust that union.
Histogram is genuinely impossible: bins are computed in the browser, so there
is no stable key, hence `tooltip_keys` being absent for it.

Because bar/line get no row, **R precomputes the values and ships a lookup**
keyed by series and mark (`tooltip_payload()`). Every mark covers a group of
rows, so a field is only sendable when it is constant within that group -
`check_tooltip_unique()` errors otherwise rather than picking one. Date-typed
x is refused outright: R and JS stringify dates differently and the key would
never match.

A formatter **replaces** the default tooltip entirely
(`tooltipFormatter: i ?? Ox(t)`, `customElement.js:10012`), so our JS rebuilds
the x/y lines too. R sends the axis titles for that, since it already
resolved them. Consequence: `dataTooltipValueFormat` is not honoured on the
types that use our formatter.

## Shiny (`arc_proxy()`)

**`ArcProxy` subclasses `ArcChart`.** That is the whole design: every
`set_*()` assigns a property and returns the object, S7 keeps the subclass,
so all thirteen work on a proxy with zero duplicated code. `arc_update()`
then flushes, which also means a pipeline of `set_*()` calls costs one
message and one re-render instead of N.

`createModel()` returns a model whose mapping is **live accessors** -
`xAxisField`, `numericFields`, `aggregationType`, `splitByField`,
`stackedType`, `rotated` - so writing one re-derives the query without a
layer rebuild. Names differ per type (`numericField` on histogram, `category`
on box plot; box plot's `numericFields` is read-only), which is why routing
`set_x()` through them needs a `model_fields` entry in `chart_type_map`. Not
done yet: `arc_update()` currently resends the whole config, which is correct
but coarser.

Message protocol is one handler, `"arcgisviz-chart"`, with a `method`
discriminator: `config` (deepMerge over the stored config, rebuild the
model), `element` (write `<arcgis-chart>` accessors), `model` (write
`ChartModel` accessors), `call` (invoke a method). The widget keeps `iLayer`
and the merged config in its factory closure, so **the data never crosses the
wire twice**.

`set_filter()` uses the element's `runtimeDataFilters`
(`Pick<WebChartQuery, "where" | "objectIds" | ...>`, `web-chart.d.ts:591`),
which requeries the layer the chart already holds - no model rebuild at all,
the cheapest interaction available. The model's `setDataFilters()` is the
persistent half and is not wired up.

Events become `input$<id>_selection`/`_legend`/`_axes`/`_colors`/
`_series_order`/`_status`/`_data`, plus one `_error` carrying a `kind`.
Three traps, all handled in `cleanPayload()`/the factory: payloads carry the
circular `model` and must be stripped; `selectionIndexes` is a JS `Map` that
stringifies to `{}`; and OIDs and indexes only exist if
`returnSelectionOIDs`/`returnSelectionIndexes` are set at render time.
`arcgisConfigChange` is deliberately not subscribed - it fires on our own
writes and would loop.

## Maps (`arc_map()`), and why they are not charts

`<arcgis-map>` takes **live `@arcgis/core` instances**, not a JSON config -
`map: Map`, `basemap: Basemap | string`, `graphics: Collection<Graphic>`. So
there is no `createModel()`-style merge and no `config` property. R sends
`basemap`/`center`/`zoom`/`extent` (all four autocast) plus a list of layers,
and `srcjs/widgets/arcgisMap.js` constructs each layer itself.

**Maps are built from client side feature collections, not a web map
document.** `WebMap.fromJSON()` is not called and the Web Map Specification is
not modeled. Every layer, on both widgets, is an **`IFeatureLayer`** built by
`as_feature_layer()` - one producer, not one per widget. Its
`featureCollection` comes from `arcgisutils::as_feature_collection()` and its
`layerDefinition` from `arcgisutils::as_layer_definition()`, including the
renderer via that function's own `drawing_info` argument. **Use the
arcgisutils builders and pass their bare lists through; never hand-assemble a
layer shape.** The JS reads `featureCollection.layers[0]` off it and hands the
pair to a `FeatureLayer`'s `source`. Two SDK converters do the rest and
neither should be hand-rolled: `FeatureSet.fromJSON()` (Esri feature JSON ->
`Graphic`s, and `esriGeometryPoint` -> the `"point"` `geometryType` wants) and
`renderers/support/jsonUtils.fromJSON()`.

`opacity` and `visibility` are properties of the layer itself, not of the
`layerDefinition` - `visibility`, not `visible`, is the spec's name
(`ILayer`, `rest-js-types.d.ts:1324`).

`viewOnReady()` gates everything - `mapEl.map` is not there before it
resolves, so layers are added after. **Proxy messages await the same promise**
(`whenReady()`, memoized in the factory): an observer that fires on app start
can reach the widget before `renderValue()` has finished, and without the gate
it lands on an undefined `mapEl.map`.

**A map renderer resolves per feature against the layer**, so the
`uniqueValue` branch that charts can only reach while aggregating is always
available here. `map_renderer()` is therefore simpler than
`color_renderer()`: numeric -> `continuous_renderer()` (shared verbatim),
anything else -> `unique_value_renderer()`, no `arcgisviz_color` code column
and none of the amCharts5 workaround. `geometry_symbol_map` is the map's
answer to `chart_type_map`'s `symbol_*` entries - the geometry decides the
symbol, not the chart type.

`add_layer(color =)` takes a bare column; a **fixed** colour is `palette`
with no `color`, since a map layer has one symbol either way. `as_widget()`
is an S7 generic with `ArcChart` and `ArcMap` methods.

`@arcgis/core`'s `config.js` defaults `assetsPath` to the Esri CDN when
empty, so nothing configures it. Offline use would need assets copied into
`inst/htmlwidgets/` plus `setAssetPath()`; not decided. See
`dev-docs/map-components-plan.md`.

**Hover tooltips are `popupInfo`, not an invented shape.** `add_layer(tooltip
= c(County = NAME))` writes the web map spec's own labelled field list
through `as_layer(popup_info =)`, where it lands beside `featureSet` and
`layerDefinition` on the feature collection layer. The client turns it into a
real `PopupTemplate` for its `fieldInfos` and then sets `popupEnabled =
false`: the template is there to be read, not to open a popup that would
repeat what the hover already says. Hovering is `arcgisViewPointerMove` ->
`hitTest({ include: })`, wrapped in `promiseUtils.debounce()` because the
pointer outruns the hit test - superseded calls reject with `AbortError` and
must be swallowed.

**A tooltip value is formatted by its field type, not by its JS type.**
`esriFieldTypeDate` is milliseconds from the epoch
(`arcgisutils::date_to_ms()`), with `-1` for NA (`from_esri_date()`), so a
date read off `graphic.attributes` is a 13-digit number and formatting it as
one is wrong. The JS reads `layer.fields[].type` (`Field.fromJSON` maps
`esriFieldTypeDate` -> `"date"`, `fieldType.js`) and branches on that.

**`ArcMapProxy` subclasses `ArcMap`**, the same trick as `ArcProxy`:
`set_basemap()`, `set_view()` and `add_layer()` all work on a proxy unchanged,
and `arc_update()` flushes. `arc_update()`, `set_filter()` and
`set_selection()` are S7 generics shared with the chart proxy - dispatch on
`S7::class_any` gives the friendly "must be an ArcProxy or ArcMapProxy"
error instead of S7's own "can't find method". Map-only: `set_layer()`,
`remove_layer()`, `arc_goto()`, `arc_screenshot()`.

**A proxy layer must be named**, because the name *is* the layer id
(`map_layer_id()`); an unnamed one is only positionally unique and would
collide with the rendered map's own `arcgisviz-layer-<i>`. Re-adding a name
already on the map replaces it, which is what makes `add_layer()` idempotent
across flushes.

**Map proxy payloads are serialized by us, not by Shiny.** `map_send()` runs
`widget_json()` and sends the result as a *string* the client `JSON.parse`s.
Shiny would use jsonlite, which sends `layerDefinition$fields` columnar and
breaks `Field.fromJSON` - the same trap `TOJSON_FUNC` avoids on the render
path. Message protocol mirrors the chart's: one handler, `"arcgisviz-map"`,
with a `method` discriminator (`update`, `remove`, `removeWidget`, `layer`,
`filter`, `select`, `selectBy`, `goto`, `screenshot`).

**Map furniture is `add_widget()`, one idiom for the whole SDK component
set.** A legend, layer list, search box or basemap gallery is a real
`<arcgis-*>` web component slotted into `<arcgis-map>`, and a slotted child
finds the map itself - nothing sets `referenceElement` or `view`. So the R
side is a registry (`map_widget_map`, `R/arc-map-widgets.R`) of
`component`/`position`/`props`, and the JS creates the element, sets its
`slot`, and assigns the props.

Three rules hold it together. **Each component is its own `import()`, written
out by hand**: a template literal would make webpack bundle all 179
components, while explicit imports code-split into a chunk each, so a map pays
only for the widgets it asks for (the entry bundle grew 29KB for fourteen).
**`props` is an allowlist per widget**, because most accessors take
Collections, Portals, or callbacks that cannot travel from R at all - a name
outside it errors with the ones that exist. And **positions are the element's
own slot names** (`arcgis-map/customElement.d.ts:120`), not an invented
vocabulary.

Widgets are keyed by component, so adding one twice replaces it - the same
idempotence rule a named layer has, and what makes `add_widget()` safe to
re-run through a proxy.

**The four tool widgets report back, and each one reports from a different
place.** This is not a choice; it is where the SDK puts the result.

- **`sketch`** - its own events (`arcgisCreate`/`arcgisUpdate`/`arcgisDelete`,
  gated on `state === "complete"` because they fire continuously while
  drawing). The payload is every graphic on the component's own graphics
  layer, not the one that changed.
- **`editor`** - *the layer's* `edits` event (`EditBusLayer`,
  `@arcgis/core` 5.0), never the component's: `arcgis-editor` emits only
  `arcgisSketchCreate`/`arcgisSketchUpdate`, which fire mid-gesture and carry
  no result. The event gives object ids, so the features are queried back out
  of the layer.
- **the two `*-measurement`** - `mapEl.whenAnalysisView(node.analysis)` then
  `reactiveUtils.watch()` on `analysisView.result`. There is no event at all.

Client side feature layers are editable: `FeatureLayer$editingEnabled` returns
true for a memory source, and `clientSideDefaults.js` gives them add/update/
delete capabilities and a "New Feature" template. **Edits live in the browser
only** - R hears what changed and decides whether to persist it.

**Geometry crosses back as an Esri feature set string**, which
`arcgisutils::parse_esri_json()` reads and `arc_sf()` wraps - the mirror of
`map_send()` sending a string rather than letting Shiny's jsonlite touch it.
Drawn shapes are converted out of Web Mercator first
(`webMercatorToGeographic()`), since the view draws in metres and the next
line of R rarely wants them; edited features keep the layer's own CRS. Each
feature carries an `object_id` attribute because `parse_esri_json()` builds
its data frame from `attributes` and an empty one has no rows.

**Selection is the view's `SelectionManager`, not a highlight handle.**
`mapEl.selectionManager` (`@arcgis/core` 5.0, still `@beta`) owns a selection
set across layers, highlights it, and emits `selection-change` - so the map
finally reports selection back the way charts always have. Three routes write
to the same set: `set_selection(mode = )` (`replace`/`add`/`remove`/`toggle`),
a click on a layer added with `selectable = TRUE`, and `arc_select()`, which
constructs a `SelectionOperation` - the SDK's own draw-to-select tool.
`arc_selected()` reads the event back, and `set_highlight()` styles the set by
writing the view's *named* `"default"` highlight options, since
`mapEl.highlights` is a collection keyed by name and every highlight that does
not ask for another one reads that entry.

Two things the manager needs that are easy to miss. It only selects in layers
that are its `sources`, so `syncSources()` runs after every layer add or
remove. And a selection identifier is an object id *or* a `Graphic` depending
on the layer (`views/selection/types.d.ts:78`), so the payload normalizes
through `objectIdField` rather than assuming.

`arc_select(tool = "lasso")` is the one place two spec properties hide behind
one friendly name: a lasso is the `polygon` create tool in `"freehand"`
`mode` (`views/draw/types.d.ts:20`). `"rectangle"`, `"polygon"`, `"circle"`
and `"point"` send no mode at all.

`set_filter()` on a map is the layer's `definitionExpression`. Events become
`input$<id>_click`/`_hover`/`_view`/`_selection`/`_sketch`/`_edits`/
`_measurement`/`_screenshot`, plus `_error`
carrying a `kind` (`arcgisLoadError`, `arcgisViewReadyError`, or `"proxy"`
with the failing `method` - a proxy message that throws reports itself rather
than dying in the console).

**Three event rules, all about not flooding the websocket or double-binding.**
`_hover` fires only when the feature under the pointer *changes*. `_view` is
debounced 250ms, because `arcgisViewChange` fires throughout a pan or zoom
animation. And `subscribeEvents()` is guarded by `state.subscribed`:
`renderValue()` runs again on every re-render, and listeners bound twice send
every event twice. A re-render also clears the layers the previous one left
behind (`removeLayers(null)`) rather than adding to them.

## Deliberately deferred (don't "fix" these without asking)

- **The non-feature layer types.** `WebChart$iLayer` is
  `IFeatureLayer | IImageServiceLayer | ITiledImageServiceLayer | IWCSLayer`
  in the spec. `IFeatureLayer` is modeled (`R/types-feature-layer.R`); the
  other three are not, and a layer here always carries a client side
  `featureCollection` rather than a service `url`.
- **Geometry types** (`IPoint`/`IPolygon`/etc.) - handled elsewhere, not
  modeled in this package's type registry. `WebChartDataFilters$geometry`
  stays `class_any`.
- **Pie, gauge, and radar series shapes** - `web-chart.d.ts` has all of these
  in one file, so adding one is reading the relevant interface(s) there and
  following the `arcgis-spec-types` skill's conventions plus the
  `chart_type_map` notes above. Not blocked on anything, just not done yet.
- **Calendar heat charts.** `WebChartCalendarDatePartsBinning` is modeled but
  nothing sets it. A heat series with `xTemporalBinning` takes the client's
  calendar branch instead of the matrix one (`Te()`,
  `dist/chunks/index4.js:10833`), which is also why a matrix heat chart has
  to send a category `valueFormat` on both axes.

## Typing a property, and the `new_*()` constructors

Six rules, all learned from real divergences rather than assumed.

**`class_any` is a staging area, not a destination.** A property is
`class_any` because it has not been modeled *yet* - `featureCollection` and
`layerDefinition` currently hold bare lists from `arcgisutils`,
`WebChartDataFilters$geometry` is handled elsewhere. None of that is a
reason it should stay untyped. The moment a *user* is expected to write a
value there it needs a class, which is what `legendOptions` did the moment
titling a colour ramp became a user task.

**For renderer-side types the web map specification wins over
`@arcgis/core`,** and the two genuinely diverge - this is not a formality.
`legendOptions` is the worked example: `@arcgis/core` splits it into
`VisualVariableLegendOptions` (`showLegend`, `title`) plus a separate
`SizeVariableLegendOptions`, while the web map spec has **one shared object**
with seven properties referenced by ten different parents. Model the spec.
Charts-side types still come from `@arcgis/charts-components`' bundled
`.d.ts` - see `arcgis-spec-types`.

**Prune properties belonging to families this package doesn't model, and say
why in a comment.** The precedent is `authoringInfo`, omitted throughout as
authoring metadata nothing reads. `ILegendOptions` likewise drops `dotLabel`
and `unit` (dotDensity renderers) and `minLabel`/`maxLabel` (heatmap
renderers). Prune by *family*, never because a property looks unused.

**A shared spec object stays one class; per-parent constraints are
documented, not modeled.** `showLegend` is unavailable under
`uniqueValueRenderer`, so that is a line in `ILegendOptions`' docs rather
than a second near-duplicate class.

**A `type` discriminator is fixed by its class, so it defaults** - it is
never restated at a call site. `s7x::property_scalar(class_character,
default = "simple")`. Hardcoded, not an enum: there is exactly one valid
value, so an enum would validate nothing. Only the six classes a user
constructs carry this (3 renderers, 3 symbols); the ~21 chart-internal ones
are still threaded from `chart_type_map` by `build_webchart()`. This is also
what would make a future `from_json()` possible - the discriminator is the
"which class do I construct into" knowledge CLAUDE.md files as missing.

**Any class a user authors gets a `new_*()` helper** when building it would
otherwise mean naming an S7 class or typing a spec-cased value. They live in
`R/constructors.R` and share one shape: a friendly kebab-case `type` first,
then `...` of that type's own properties.

- `...` is **named-only**. Unnamed, a value lands on the first property -
  which is `type` - and silently replaces the discriminator.
- Unknown property names error with the valid list; S7's own message is a
  bare `unused argument (nope = 1)`.
- Friendly values in, spec values out: `"unique-value"` -> `"uniqueValue"`,
  `"backward-diagonal"` -> `"esriSFSBackwardDiagonal"`, `"descending"` ->
  `"descendingValues"`. Style names are **derived from the enum's own
  variants**, not tabled, so a style added to the spec needs no change here.
- Colours are written as names or hex (`"steelblue"`, `"#b8282899"`) and
  coerced by `parse_color()`. `Color` itself stays r/g/b/a - that exception
  is deliberate, so the coercion belongs in the helper, not the class.
- **Unset arguments are omitted, never passed as `NA`.** An omitted property
  already defaults to NA and drops out of the wire format, and an enum
  cannot be constructed from a logical `NA` at all.
- Defaults that vary by family belong in the map, not the code path: a
  marker has no `"solid"` style, so `symbol_styles` carries `"circle"` for
  markers and `"solid"` for fills and lines.

**Still open: `class_list` properties cannot be resolved.** `visualVariables`,
`stops`, and `uniqueValueInfos` declare no element class, so a user still
writes `IColorVisualVariable(...)`/`IColorStop(...)` by hand - the one place
the `new_*()` family does not yet reach. Fixing it needs either more helpers
or a `property_list_of()` in `s7x`. `s7x` is this package's own dependency
and is fair game to work in (cloned at `../s7x`).

## Naming

**Never name a function or argument `*_for` or `resolve_*`.** No
`palette_for()`, no `resolve_stops()`. Both read as machine-generated. Name
the thing it returns or the thing it does: `palette_stops()`,
`discrete_colors()`, `chart_axis()`.

The public API takes its vocabulary from the grammar of graphics. A user who
knows ggplot2 should be able to guess a name and be right: `arc_histogram()`
not `arc_binned_bar()`, `bins` not `binCount`, `set_color()` not
`set_color_mapping()`. Friendly values stay kebab-case with no spec prefixes
("side-by-side", not "sideBySide"). Nothing in the public surface exposes an
S7 class or a spec enum value.

## Comments

**Hard limit: 3 lines per comment block.** Not a guideline, not "about" 3 -
if a block runs to 4 lines it gets cut, and a block that can't say it in 3
is a block that shouldn't exist. This is the single most violated rule in
this file.

Most comments aren't needed at all. Comment only what the code can't say -
a non-obvious external contract, a surprising constraint, a spec citation
(`web-chart.d.ts:1274`). Don't restate what the code does, don't justify
the design, don't narrate the reasoning that led there. Never write a
comment that enumerates a data structure's fields; the structure is right
there.

## R style: rlang first, cli for all messaging

Reach for `{rlang}` before base R, always. `rlang::is_null()` not
`is.null()`, `rlang::is_empty()` not `length(x) == 0`,
`rlang::is_list()`/`is_atomic()`/`is_scalar_character()` not the `is.*()`
equivalents, `rlang::arg_match0()` not `match.arg()`. Reference:
<https://rlang.r-lib.org/llms.txt>.

Every user-facing condition or message goes through `{cli}` -
`cli::cli_abort()`, `cli::cli_warn()`, `cli::cli_inform()`. Never `stop()`,
`warning()`, `message()`, or `paste0()`-built strings. Use inline markup
(`{.arg x}`, `{.field {col}}`, `{.val {x}}`, `{.fn set_type}`), pluralize
with `{?s}`, and pass `call = call` with a `call = rlang::caller_env()`
argument so errors point at the user's frame. Load the `r-lib:cli` skill
before writing any of it.

## Conventions worth knowing before editing `R/`

- **Never invent a JSON shape as a bare list.** If a thing has a name in a
  spec, model it as an S7 class written faithfully from that spec
  (`IFeatureLayer`, the renderers).

  **`arcgisutils` is a reference, not an authority.** It is the **S3
  implementation of the same problem** this package is solving with S7, and
  the S7 machinery here is the direction of travel - these types migrate
  *into* arcgisutils later. So do not reflexively route everything through
  it, and do not treat a bare list it returns as the final shape for
  something. What it is genuinely good for:

  - **Checking behavior.** `as_fields()` (`infer_esri_type()` is deprecated
    as of 0.4.0) decides the `esriFieldType*` for an R column,
    `ptype_tbl()`/`fields_as_ptype_df()` go the other way, and
    `is_date()`/`date_to_ms()`/`from_esri_date()` own date handling. An S7
    analogue must agree with these. Read the implementation, not just the
    docs - the repo is cloned at `../arcgisutils`. Index:
    <https://r.esri.com/arcgisutils/llms.txt>.
  - **Not re-deriving what already works.** `as_layer()`,
    `as_layer_definition()` and `as_feature_collection()` take the arguments
    you would otherwise patch in by hand (`drawing_info`,
    `layer_definition`, `id`, `popup_info`), so use those arguments rather
    than reaching into a returned list to re-assemble its parts.

  Calling one of those is a convenience while the S7 equivalent does not
  exist, not a rule about where the shape belongs.

- S7 classes: `Foo := new_class(properties = list(...))` - no name string
  as the first arg (breaks `:=`'s inference, silently binds to `parent`
  instead and errors). `s7x::` is always fully-qualified in package code.
- Optional properties: `NA` already satisfies `s7x::class_string`/
  `class_float`/`class_boolean`/`Enum` (has `allow_na = TRUE`) - no
  wrapping needed, **including when the property is simply omitted from a
  constructor call** (verified by `tests/testthat/test-type-defaults.R`;
  this used to be false and broke on omission until a round of `s7x` fixes
  to `new_enum()`/`property_scalar()`/`property_range()`/`property_union()`
  default-value handling). Only optional *object-typed* properties need
  `s7x::property_union(Type, NULL, default = NULL)` - and that literal
  `NULL` really is respected on omission now (`property_union()` used to
  conflate "no `default` arg supplied" with "`default = NULL` supplied
  explicitly" and would deep-default into `Type` instead; fixed).
- `Color` (`R/color.R`) is `r`/`g`/`b`/`a` (four `class_float`), not the
  raw `[r,g,b,a]` tuple the spec uses - a deliberate exception, keep it.
- `DESCRIPTION`'s `Collate:` field is load-bearing - `R/` files have real
  cross-file dependencies. Add new files to it in dependency order or
  `load_all()` breaks with "object not found".
- After writing/editing any S7 class, diff its property names against the
  relevant `@arcgis/charts-components` `.d.ts` interface by hand (see
  "Source of truth" above) - `data-raw/spec-type-registry.json` is stale,
  don't diff against it anymore.
- roxygen2 doesn't recognize `:=` as an assignment operator, so a bare
  `#' @export` above `Foo := new_class(...)` is silently dropped - no
  NAMESPACE entry, no Rd file, no error. Every `:=`-defined class needs an
  explicit `#' @name Foo` (with at least a one-line title) alongside
  `@export` or it never gets exported. Run `just document` twice when
  adding new cross-references between doc blocks (`[Foo()]` links) - the
  first `devtools::document()` pass can report a stale "could not resolve
  link" warning for a topic documented in the same run; it clears on the
  second pass once the new Rd file is on disk.
- Two functions sharing one Rd via `@rdname` share a pkgdown topic too, so
  `_pkgdown.yml` must list exactly one of them or `check_pkgdown()` reports
  it double-listed. Deleting an exported function also needs its `man/*.Rd`
  removed by hand - `document()` won't, and `R CMD check` then fails with
  "listed as exports, but not present in namespace".

## Standing rule from global config

Never write/run ad-hoc inline scripts (`python -c`, `node -e`, etc.) for
file operations or data manipulation, even read-only checks - this
project has been burned by that before. Data-generating R scripts live
under `data-raw/` as real files, reviewed, then run with
`R -q -f data-raw/whatever.R`. One-off `R -q -e` inspection/verification
snippets are fine.
