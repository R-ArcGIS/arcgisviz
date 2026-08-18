# arcgisviz

An R package binding to the ArcGIS Maps SDK Charts capabilities
(`@arcgis/charts-components`). Two halves: an S7 type layer in R that
mirrors the JS chart config JSON shape, and an htmlwidget that renders
`<arcgis-chart>` in the browser from that config plus a data source.

**Source of truth for types is `@arcgis/charts-components`’s own bundled
spec**, not a separate package.
`@arcgis/charts-model`/`@arcgis/charts-spec` (the packages this project
originally generated types from) are on an independent, stalled version
line (`4.32.15`, the latest published, with no newer release) that has
diverged from what `@arcgis/charts-components` (tracking SDK `5.1.x`)
actually ships and runs - confirmed by real divergence (`subTitle`
renamed to `subtitle`, `WebChartScatterPlotSeries` renamed to
`WebChartScatterplotSeries`, temporal binning restructured, etc). Both
packages were removed from `package.json`/`node_modules` for this
reason. Read types from: -
`node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts` - the
WebChart config shape (all `WebChart*`/series/axis/query interfaces, one
file). - `.../dist/spec/chart-object-literals.d.ts` - `WebChart*` enums
(as const objects + derived types). -
`.../dist/spec/rest-js-types.d.ts` - `Color`, `IFont`,
`ISimpleFillSymbol`/
`ISimpleLineSymbol`/`ISimpleMarkerSymbol`/`ITextSymbol`,
`IStatisticDefinition`. - `.../dist/spec/rest-js-object-literals.d.ts` -
`RESTUnits` and REST-prefixed symbol-style consts (mostly unused
directly - the non-REST-prefixed versions in rest-js-types.d.ts are what
properties actually reference). - `.../dist/spec/data-source.d.ts` -
`TimeIntervalInfo`, `RGBObject`.

**Don’t hand-write types from a JSON Schema.** There is one in the dist
(`dist/chunks/index4.js:14` holds a draft-07 object with a full
`definitions` block, and `dist/json-schema/index.d.ts` types that
object’s shape), but the `.d.ts` files above are the readable source and
stay authoritative - the schema carries no type detail the declarations
lack, and its own `IDrawingInfo$renderer` is untyped.
`data-raw/resolve-spec-types.R` and `data-raw/spec-type-registry.json`
(the old JSON-Schema-driven pipeline) are **stale/archival** - don’t
treat them as current, and don’t mechanically regenerate
`R/types-*.R`/`R/enums-*.R` from them. Types are now hand-written
directly against the `.d.ts` files above, same as the imperative-API
`data-raw/<model>.json` docs always were (those are separately stale
too - they came from the removed `@arcgis/charts-model` package’s
method-level `.d.ts` files, describing the `createModel()`/JS-wiring
path, which is not current work - see `arcgis-js-widget` skill).

## Commands

Use `just` (see `justfile`), not raw `Rscript`/`bun` calls:

``` sh
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
`dev/set-labs.R`), rendered in the Viewer and using
[`datasets::penguins`](https://rdrr.io/r/datasets/penguins.html). These
become user-facing tutorials later, so write them to be read.

## Two skills, load them for the relevant work

- **`arcgis-spec-types`** - hand-writing `s7x`-based S7 classes in `R/`
  directly from `@arcgis/charts-components`’s bundled `.d.ts` spec (see
  above - no JSON Schema, no mechanical resolver anymore). Load this
  before adding a new chart type or touching any `R/types-*.R` /
  `R/enums-*.R` / `R/color.R` file.
- **`arcgis-js-widget`** - the htmlwidget: `srcjs/`, webpack config,
  `R/arcgis-chart-widget.R`, the `createModel`/`<arcgis-chart>`
  contract. Load this before touching anything JS-side or the R widget
  wrapper.

Both skills point to more detail: `dev-docs/js-widget-architecture.md`
for the full JS/data-flow writeup.

## Current state, in one paragraph

Bar chart, scatterplot, and line chart (incl. combo bar-line, which
needs zero new code since `WebChart$series` is an untyped `class_list`)
have complete S7 type stacks (config classes + enums), rebuilt against
`@arcgis/charts-components`‘s bundled spec (see above) and verified to
construct end-to-end with realistic, minimally-specified data (see
`tests/testthat/test-type-defaults.R`). On top of that sits a public API
that exposes no S7 objects (`R/arc-chart.R`:
`arc_chart() |> set_type() |> set_x() |> set_y()`, plus
[`arc_bar()`](http://r.esri.com/arcgisviz/reference/arc_bar.md)/[`arc_scatter()`](http://r.esri.com/arcgisviz/reference/arc_scatter.md)/[`arc_line()`](http://r.esri.com/arcgisviz/reference/arc_line.md)
sugar, tidy-eval bare column names, friendly kebab-case type names) and
a data -transfer layer (`R/arc-data.R`) that turns a data frame + config
into the widget payload. That public API now covers mapping
([`set_x()`](http://r.esri.com/arcgisviz/reference/set_x.md)/[`set_y()`](http://r.esri.com/arcgisviz/reference/set_x.md)/
[`set_stat()`](http://r.esri.com/arcgisviz/reference/set_stat.md)), text
([`set_labs()`](http://r.esri.com/arcgisviz/reference/set_labs.md)),
colour and grouping
([`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md),
see below), and scales
([`set_axis()`](http://r.esri.com/arcgisviz/reference/set_axis.md)/[`set_flipped()`](http://r.esri.com/arcgisviz/reference/set_flipped.md)/[`set_position()`](http://r.esri.com/arcgisviz/reference/set_position.md)).
Six chart types are modeled: bar, line, scatter, histogram, box plot,
and heat (plus combo bar-line for free). Pie, gauge, and radar are not.
There is no legend surface yet (`WebChart$legend` is modeled but nothing
sets it), which grouped charts have made worth adding - they are the
first thing here that produces more than one series, and each series’
`name` is what a legend would show.

Two shapes worth knowing before adding a seventh chart type.
`chart_type_map` (`R/arc-chart.R`) carries `config_class`, `has_y`,
`aggregates`, and `tooltip_fields` per type, and `build_webchart()`
reads them rather than branching on the type name. Chart types whose
spec defines a `WebChart` subtype get it as a real S7 subclass
(`WebBoxPlot`, `WebHeatChart`), which is how they inherit the
`as_vector()` method that drops unset properties. And **every axis must
carry `type = "chartAxis"`**: `deepMerge()` maps over the source array
(`srcjs/widgets/arcgisChart.js:24`), so an axis that compacts away to
nothing shortens `axes` and deletes one of the model’s own.

Options that belong to one chart type get a `set_<type>()` function
([`set_histogram()`](http://r.esri.com/arcgisviz/reference/arc_histogram.md),
[`set_boxplot()`](http://r.esri.com/arcgisviz/reference/arc_boxplot.md))
whose arguments are also arguments on the `arc_<type>()` shortcut, both
documented in one Rd via `@rdname`. Not one exported function per
property - that contradicts
[`set_axis()`](http://r.esri.com/arcgisviz/reference/set_axis.md) and
doesn’t scale. They land in `ArcChart@series_opts`/`@config_opts`
(already keyed by spec property name) and are spliced in by
`build_webchart()`; `merge_opts()` makes repeated calls layer rather
than reset, the same rule as
[`set_labs()`](http://r.esri.com/arcgisviz/reference/set_labs.md).

## Serialization

`s7x::to_json(x, ..., pretty = FALSE)` works for any S7 config class in
this package - it’s `as_vector(x)` +
`yyjsonr::write_json_str(auto_unbox = TRUE)`, a generic `S7_object`
method in `s7x`.

**`as_vector()` is the single extension point for the wire format.** It
recurses through the generic (`as_vector_value()`,
`s7x/R/as_vector.R:30`), so a method on a nested class fires during the
parent’s walk. `R/arc-data.R` registers these, and `to_json()` inherits
all of them for free:

- `WebChart` - drops unset (NA/NULL) properties via `compact_config()`.
- the three `WebChart*Series` classes - emit `query: null` when the
  query is unset, the client-side signal to delete a default.
- `Color` - the spec’s raw `[r,g,b,a]` tuple, undoing this package’s
  deliberate r/g/b/a exception. A partly-specified color returns `NULL`
  and drops out.
- `WebChartScatterplotSeries` also returns `additionalTooltipFields` as
  a list. `auto_unbox = TRUE` would send a one-element `class_character`
  as a bare string, and the client spreads that value into the query’s
  `outFields` (`fu()`, `dist/chunks/index2.js:7857`) - a string spreads
  to its own characters. **Any spec property typed `string[]` needs
  this**, whatever the R property’s type.

Two mechanics this depends on: `S7::super(x, S7::S7_object)` to reach
the default method from an override (otherwise infinite recursion), and
`.onLoad()`’s
[`S7::methods_register()`](https://rconsortium.github.io/S7/reference/S7_on_load.html)
in `R/zzz.R` - without it, methods on another package’s generic are
registered at build time and lost on install.
`S7::method(s7x::as_vector, X) <- f` does *not* work (the replacement
form would assign back through `::`), hence the
`@importFrom s7x as_vector`.

`from_json()` (JSON -\> S7 object) doesn’t exist yet - harder problem,
needs to know which class to construct into.

## Data transfer (R -\> browser)

`R/arc-data.R` builds the `createModel()` payload; its header comment
cites the exact `@arcgis/charts-components` dist files/functions each
rule comes from, and `tests/testthat/test-data-transfer.R` asserts the
shapes. The non-obvious parts:

- `createModel()` is called **twice**, and R sends both `chartType` and
  `config`. A sparse config can’t go to `createModel()` alone - a
  `WebChart` needs a full axes/labels/symbol tree or the engine throws
  “There are no X axes on chart” - and `getDefault*Chart()` needs a
  `CommonStrings` localization bundle we can’t construct. So:
  `createModel({ iLayer, chartType })` harvests the model’s own
  defaults, `deepMerge()` layers R’s sparse config over
  `defaults.config`, then `createModel({ iLayer, config })` builds the
  real model from the complete config. Assigning `model.config`
  post-setup instead re-adds series before axes and fails.
- `deepMerge()` treats **`null` as delete**, not as a value. It’s R’s
  only way to unset one of the model’s defaults, since an absent key
  just leaves the default in place. `stat = "identity"` needs it: the
  default bar/line series ships a count aggregation (`$e()`,
  `dist/chunks/index.js`) and `BarAndLineNoAggregation` requires
  `query.outStatistics` to be `undefined` (`ga()`,
  `dist/chunks/index2.js:593`).
- **Aggregation is `stat`, and it maps 1:1 onto ggplot2’s.** `ga()`
  picks the bar/line subtype purely from the query shape: no
  `outStatistics` -\> `BarAndLineNoAggregation` (`geom_col()`,
  `stat = "identity"`); `groupByFieldsForStatistics` + `outStatistics`
  -\> `BarAndLineMonoField` (`geom_bar()`/`stat_summary()`). Under
  aggregation the series’ `y` must name the `outStatisticFieldName`, not
  the source column - which is why `ArcChart` holds the *mapping*
  (`x`/`y`/`stat`) and `@webchart` is a computed getter
  (`build_webchart()`), not a stored, eagerly-mutated object.
- `iLayer` needs `layerType = "ArcGISFeatureLayer"` and carries the data
  at `featureCollection$layers[[1]]$featureSet` / `$layerDefinition`.
  The converter (`gi`, `dist/chunks/index2.js`) reads *only* those paths
  plus `fields`/`objectIdField`/`geometryType`/`spatialReference` -
  which is precisely what
  [`arcgisutils::as_feature_collection()`](https://rdrr.io/pkg/arcgisutils/man/layer_json.html)
  emits.
- Unset properties must be **dropped**, not sent as JSON `null` - the
  default `as_vector()` method materializes every property (16 of
  `WebChart`’s 20 top-level ones are NA/NULL for a minimal chart), and
  an explicit null would override a default instead of falling back to
  it. See “Serialization” above: this and the `Color` tuple conversion
  are both `as_vector()` methods, not a bespoke pass.
- **We serialize the widget payload ourselves.** The widget sets
  `attr(x, "TOJSON_FUNC") <- widget_json`, htmlwidgets’ documented hook
  for replacing its serializer outright, so nothing depends on
  htmlwidgets’/jsonlite’s defaults. `widget_json()` is yyjsonr-based
  (same engine as
  [`s7x::to_json()`](https://s7x.josiah.rs/reference/to_json.html)), and
  yyjsonr’s defaults are the correct ones here where jsonlite’s are not:
  `dataframe = "rows"` (jsonlite defaults to “columns”, which silently
  breaks `layerDefinition$fields` - the JS does
  `fields.map(Field.fromJSON)` and needs an array of objects) and
  `str_specials`/`num_specials = "null"` for NA. Prefer our own
  serialization over a host package’s wherever the option exists.
  htmlwidgets hands the function the whole payload (`x`, `evals`,
  `jsHooks`), not just `x`, and expects a JSON string back.
- Single-shot only: the whole collection goes over in one payload.
  [`arcgisutils::as_esri_features()`](https://rdrr.io/pkg/arcgisutils/man/features.html)
  is the per-feature JSON a future batched path would stream (cf. the
  SDK’s large-collection sample, which does that via `applyEdits()` on a
  *live* layer), but nothing needs it yet.

## Colour (`set_color()`), and the two mechanisms it needs

Colour goes over as `WebChart$chartRenderer` + `colorMatch = TRUE`. The
client hands that renderer to `@arcgis/core`’s `jsonUtils.fromJSON()`
and resolves a symbol **per data item** via
`symbolUtils.getDisplayedSymbol()` (`dist/chunks/index2.js:1541`,
`:1612`), so no multi-series split-by is involved. The renderer classes
are hand-written from the **web map** specification, not the charts spec
(`IDrawingInfo$renderer` is `any`) and not the web *scene* spec (its
renderers reference `Symbol3D`, SceneView only).

Which renderer to send is decided by the **query shape, not the chart
type**, and both branches were established empirically:

- **Not aggregating** - a `simple` renderer carrying a `colorInfo`
  visual variable. Continuous colour spreads the ramp’s own stops across
  `range(column)` and lets the client interpolate. *Categorical* colour
  uses the same mechanism, because a `uniqueValue` renderer is silently
  ignored on the scatter (amCharts5) path: `chart_data()` appends an
  `arcgisviz_color` integer-code column and the VV gets one stop per
  code, so no value ever falls between stops and interpolation never
  kicks in. Stop `label`s carry the level names.
- **Aggregating** - a `uniqueValue` renderer on the grouped column. A
  derived code column can’t work here because the query returns only
  `groupByFieldsForStatistics` plus the statistics. For the same reason,
  a *numeric* colour column while aggregating is an error, not a silent
  no-op - it can only be a gradient, so it can’t become a group either.

**Heat charts are the exception**: cells are shaded by the series’ own
`gradientRules`/`classBreaksRules`, not by `chartRenderer`, and the
value is the cell count so there is no column to map.
`set_color(chart, palette =)` takes `palette` alone. An Esri ramp
travels by *name* in `classBreaksRules$colorRampInfo` and the client
generates the class breaks itself (`serial-chart-data.js:487`, and
`generateHeatChartClassBreaks()` at `customElement.js:18668`, which runs
for heat and nothing else). Any other palette collapses to the
two-colour `gradientRules$colorList` the spec allows. Ramps tagged
`heatmap` in `esri_color_ramps` are the ones built for this.

**Colouring by a column other than `x` groups the chart**, on the types
that support it. Dodging and stacking need *multiple series* -
`stackedType` is documented as “how the bars/lines should be placed when
multiple series are rendered” - and the client decides a chart is split
purely from the **`where` clause on each series’ query**, not from the
chart type: `ga()` (`dist/chunks/index2.js:593`) returns
`BarAndLineSplitBy` when `where` is a real filter alongside
`outStatistics`, and `BarAndLineSplitByNoAggregation` when there is no
`outStatistics`. So `chart_split()` emits one series per level, each
with `where = "col='level'"` (single quotes doubled, mirroring
`normalizeWhereClause()`), a unique `id`, and `name = level` for the
legend.

**The `where` clauses never actually run.** Having read them, the client
builds *one* query grouped by `[x, splitField]` (`os()`,
`index2.js:1816`) and reshapes that single result, keying each series’
values by its own statistic output field - which `ns()` (`:1793`) takes
verbatim from `outStatisticFieldName` when it is set. So every split
series needs a **distinct** `outStatisticFieldName`, and its `y` must
equal it. Sharing one name makes all series read the same column and
draw identical bars, which looks like the filter being ignored. Hence
`series_aggregation(suffix =)`: `_0` unsplit (the SDK’s own convention),
`_<level>` per split series.

Only **bar, line, combo, and box plot** have split-by subtypes
(`utils/misc/interfaces.d.ts:7`); scatter reads `series[0]` and ignores
the rest. `chart_type_map$splits` gates it, so the other types keep
colouring per item through `chartRenderer`.

A split series carries its colour on **its own symbol** (`fillSymbol` /
`lineSymbol`, per `chart_type_map$symbol_property`) and the chart sends
no `chartRenderer` at all. A `uniqueValue` renderer would also work -
the client honours one when `renderer.field` equals the split field
(`index2.js:1405`) - but the symbol path is what `colorMatch = false`
documents (“the colors from the config, and then from the color ramps
will be used”), and it doesn’t depend on that match holding.

[`set_position()`](http://r.esri.com/arcgisviz/reference/set_position.md)
/ the `position` argument on
[`arc_bar()`](http://r.esri.com/arcgisviz/reference/arc_bar.md)/[`arc_col()`](http://r.esri.com/arcgisviz/reference/arc_col.md)/
[`arc_line()`](http://r.esri.com/arcgisviz/reference/arc_line.md) map
ggplot2’s `dodge`/`stack`/`fill` onto
`sideBySide`/`stacked`/`stacked100`. A split chart defaults to `dodge`;
an unsplit one sends no `stackedType` at all.

A colour mapping is otherwise unreadable on hover, so the coloured-by
column also goes into `series$additionalTooltipFields`. That property
exists **only on the scatterplot series** (`web-chart.d.ts:845`) - the
shared `WebChartSeries` has `dataTooltip*` formatting and nothing that
names a field - so bar, line, histogram, box, and heat tooltips still
show only x and y. `tooltipFormatter` would cover them but it’s a JS
callback on the component, not config JSON, so it can’t travel from R.

Palettes live in `R/sysdata.rda`, built by `data-raw/color-palettes.R`
from `@arcgis/core/smartMapping/symbology/support/colors.js`: 521 ramps
(name, tags, stops), plus `esri_series_palette` (ColorBrewer Paired-10,
the SDK’s own series palette at `chunks/index.js:45`) and
`esri_default_ramp` (`"Blue 3"`, its `defaultColorRampForCharts` at
`chunks/class-breaks.js:475`). `palette` also takes any vector of R
colours, parsed by
[`grDevices::col2rgb()`](https://rdrr.io/r/grDevices/col2rgb.html) in
`R/color.R`.

`R/palettes.R` turns that catalogue into the user-facing
[`esri_palettes()`](http://r.esri.com/arcgisviz/reference/esri_palettes.md),
one row per ramp, filterable by `type`/`color_mode`/`hue`/`tag`. Two
facts about the tag vocabulary hold across all 521 and are what let
those be scalar columns rather than list ones: every ramp carries
**exactly one** of `light`/`dark`, and **at most one** of
`sequential`/`diverging`/`categorical` (118 carry none - the
`centered-on`, `extremes`, and `heatmap` families).
[`palette_tags()`](http://r.esri.com/arcgisviz/reference/palette_tags.md)
is the full vocabulary. It builds the frame with
[`arcgisutils::data_frame()`](https://rdrr.io/pkg/arcgisutils/man/utilities.html),
which adds a `tbl` class for printing without pulling in tibble.

## Deliberately deferred (don’t “fix” these without asking)

- **Live FeatureLayer / non-featureCollection layer types.**
  `WebChart$iLayer` is
  `IFeatureLayer | IImageServiceLayer | ITiledImageServiceLayer | IWCSLayer`
  in the spec but stays `class_any` here - charts are built from a
  `type: "featureCollection"` JSON blob via
  [`arcgisutils::as_layer()`](https://rdrr.io/pkg/arcgisutils/man/layer_json.html),
  not a live layer reference. Don’t model the live-layer types.
- **Geometry types** (`IPoint`/`IPolygon`/etc.) - handled elsewhere, not
  modeled in this package’s type registry.
  `WebChartDataFilters$geometry` stays `class_any`.
- **Pie, gauge, and radar series shapes** - `web-chart.d.ts` has all of
  these in one file, so adding one is reading the relevant interface(s)
  there and following the `arcgis-spec-types` skill’s conventions plus
  the `chart_type_map` notes above. Not blocked on anything, just not
  done yet.
- **Calendar heat charts.** `WebChartCalendarDatePartsBinning` is
  modeled but nothing sets it. A heat series with `xTemporalBinning`
  takes the client’s calendar branch instead of the matrix one (`Te()`,
  `dist/chunks/index4.js:10833`), which is also why a matrix heat chart
  has to send a category `valueFormat` on both axes.

## Naming

**Never name a function or argument `*_for` or `resolve_*`.** No
`palette_for()`, no `resolve_stops()`. Both read as machine-generated.
Name the thing it returns or the thing it does: `palette_stops()`,
`discrete_colors()`, `chart_axis()`.

The public API takes its vocabulary from the grammar of graphics. A user
who knows ggplot2 should be able to guess a name and be right:
[`arc_histogram()`](http://r.esri.com/arcgisviz/reference/arc_histogram.md)
not `arc_binned_bar()`, `bins` not `binCount`,
[`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md) not
`set_color_mapping()`. Friendly values stay kebab-case with no spec
prefixes (“side-by-side”, not “sideBySide”). Nothing in the public
surface exposes an S7 class or a spec enum value.

## Comments

Keep them terse. More than ~5 lines in one block is too much, and most
comments aren’t needed at all. Comment only what the code can’t say - a
non-obvious external contract, a surprising constraint, a spec citation
(`web-chart.d.ts:1274`). Don’t restate what the code does, don’t justify
the design, don’t narrate the reasoning that led there.

## R style: rlang first, cli for all messaging

Reach for [rlang](https://rlang.r-lib.org) before base R, always.
[`rlang::is_null()`](https://rlang.r-lib.org/reference/type-predicates.html)
not [`is.null()`](https://rdrr.io/r/base/NULL.html),
[`rlang::is_empty()`](https://rlang.r-lib.org/reference/is_empty.html)
not `length(x) == 0`,
[`rlang::is_list()`](https://rlang.r-lib.org/reference/type-predicates.html)/`is_atomic()`/`is_scalar_character()`
not the `is.*()` equivalents,
[`rlang::arg_match0()`](https://rlang.r-lib.org/reference/arg_match.html)
not [`match.arg()`](https://rdrr.io/r/base/match.arg.html). Reference:
<https://rlang.r-lib.org/llms.txt>.

Every user-facing condition or message goes through
[cli](https://cli.r-lib.org) -
[`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html),
[`cli::cli_warn()`](https://cli.r-lib.org/reference/cli_abort.html),
[`cli::cli_inform()`](https://cli.r-lib.org/reference/cli_abort.html).
Never [`stop()`](https://rdrr.io/r/base/stop.html),
[`warning()`](https://rdrr.io/r/base/warning.html),
[`message()`](https://rdrr.io/r/base/message.html), or
[`paste0()`](https://rdrr.io/r/base/paste.html)-built strings. Use
inline markup (`{.arg x}`, `{.field {col}}`, `{.val {x}}`,
`{.fn set_type}`), pluralize with `{?s}`, and pass `call = call` with a
`call = rlang::caller_env()` argument so errors point at the user’s
frame. Load the `r-lib:cli` skill before writing any of it.

## Conventions worth knowing before editing `R/`

- S7 classes: `Foo := new_class(properties = list(...))` - no name
  string as the first arg (breaks `:=`’s inference, silently binds to
  `parent` instead and errors). `s7x::` is always fully-qualified in
  package code.
- Optional properties: `NA` already satisfies
  [`s7x::class_string`](https://s7x.josiah.rs/reference/property_scalar.html)/
  `class_double`/`class_boolean`/`Enum` (has `allow_na = TRUE`) - no
  wrapping needed, **including when the property is simply omitted from
  a constructor call** (verified by
  `tests/testthat/test-type-defaults.R`; this used to be false and broke
  on omission until a round of `s7x` fixes to
  `new_enum()`/`property_scalar()`/`property_range()`/`property_union()`
  default-value handling). Only optional *object-typed* properties need
  `s7x::property_union(Type, NULL, default = NULL)` - and that literal
  `NULL` really is respected on omission now (`property_union()` used to
  conflate “no `default` arg supplied” with “`default = NULL` supplied
  explicitly” and would deep-default into `Type` instead; fixed).
- `Color` (`R/color.R`) is `r`/`g`/`b`/`a` (four `class_double`), not
  the raw `[r,g,b,a]` tuple the spec uses - a deliberate exception, keep
  it.
- `DESCRIPTION`’s `Collate:` field is load-bearing - `R/` files have
  real cross-file dependencies. Add new files to it in dependency order
  or `load_all()` breaks with “object not found”.
- After writing/editing any S7 class, diff its property names against
  the relevant `@arcgis/charts-components` `.d.ts` interface by hand
  (see “Source of truth” above) - `data-raw/spec-type-registry.json` is
  stale, don’t diff against it anymore.
- roxygen2 doesn’t recognize `:=` as an assignment operator, so a bare
  `#' @export` above `Foo := new_class(...)` is silently dropped - no
  NAMESPACE entry, no Rd file, no error. Every `:=`-defined class needs
  an explicit `#' @name Foo` (with at least a one-line title) alongside
  `@export` or it never gets exported. Run `just document` twice when
  adding new cross-references between doc blocks (`[Foo()]` links) - the
  first `devtools::document()` pass can report a stale “could not
  resolve link” warning for a topic documented in the same run; it
  clears on the second pass once the new Rd file is on disk.
- Two functions sharing one Rd via `@rdname` share a pkgdown topic too,
  so `_pkgdown.yml` must list exactly one of them or `check_pkgdown()`
  reports it double-listed. Deleting an exported function also needs its
  `man/*.Rd` removed by hand - `document()` won’t, and `R CMD check`
  then fails with “listed as exports, but not present in namespace”.

## Standing rule from global config

Never write/run ad-hoc inline scripts (`python -c`, `node -e`, etc.) for
file operations or data manipulation, even read-only checks - this
project has been burned by that before. Data-generating R scripts live
under `data-raw/` as real files, reviewed, then run with
`R -q -f data-raw/whatever.R`. One-off `R -q -e` inspection/verification
snippets are fine.
