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

There is **no JSON Schema anymore** - `@arcgis/charts-components` only ships
`.d.ts` declarations, no runtime-extractable schema object (checked; not
worth re-deriving one). `data-raw/resolve-spec-types.R` and
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

## Two skills, load them for the relevant work

- **`arcgis-spec-types`** - hand-writing `s7x`-based S7 classes in `R/`
  directly from `@arcgis/charts-components`'s bundled `.d.ts` spec (see
  above - no JSON Schema, no mechanical resolver anymore). Load this before
  adding a new chart type or touching any `R/types-*.R` / `R/enums-*.R` /
  `R/color.R` file.
- **`arcgis-js-widget`** - the htmlwidget: `srcjs/`, webpack config,
  `R/arcgis-chart-widget.R`, the `createModel`/`<arcgis-chart>` contract.
  Load this before touching anything JS-side or the R widget wrapper.

Both skills point to more detail: `dev-docs/js-widget-architecture.md` for the
full JS/data-flow writeup.

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
widget payload. Box plot, pie, gauge, histogram, and radar chart types are
not yet modeled.

## Serialization

`s7x::to_json(x, ..., pretty = FALSE)` works for any S7 config class in this
package - it's `as_vector(x)` + `yyjsonr::write_json_str(auto_unbox = TRUE)`,
a generic `S7_object` method in `s7x`.

**`as_vector()` is the single extension point for the wire format.** It
recurses through the generic (`as_vector_value()`, `s7x/R/as_vector.R:30`),
so a method on a nested class fires during the parent's walk. `R/arc-data.R`
registers three, and `to_json()` inherits all of them for free:

- `WebChart` - drops unset (NA/NULL) properties via `compact_config()`.
- the three `WebChart*Series` classes - emit `query: null` when the query is
  unset, the client-side signal to delete a default.
- `Color` - the spec's raw `[r,g,b,a]` tuple, undoing this package's
  deliberate r/g/b/a exception. A partly-specified color returns `NULL` and
  drops out.

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

## Deliberately deferred (don't "fix" these without asking)

- **Live FeatureLayer / non-featureCollection layer types.** `WebChart$iLayer`
  is `IFeatureLayer | IImageServiceLayer | ITiledImageServiceLayer | IWCSLayer`
  in the spec but stays `class_any` here - charts are built from a
  `type: "featureCollection"` JSON blob via `arcgisutils::as_layer()`, not a
  live layer reference. Don't model the live-layer types.
- **Geometry types** (`IPoint`/`IPolygon`/etc.) - handled elsewhere, not
  modeled in this package's type registry. `WebChartDataFilters$geometry`
  stays `class_any`.
- **Other chart types' series shapes** (pie, gauge, histogram, box plot,
  radar, heat) - `web-chart.d.ts` has all of these in one file now (no
  per-chart-type `.d.ts` sprawl to resolve), so adding one is just reading
  the relevant interface(s) there and following the `arcgis-spec-types`
  skill's conventions - not fundamentally blocked on anything, just not
  done yet.

## Comments

Keep them terse. More than ~5 lines in one block is too much, and most
comments aren't needed at all. Comment only what the code can't say - a
non-obvious external contract, a surprising constraint, a spec citation
(`web-chart.d.ts:1274`). Don't restate what the code does, don't justify
the design, don't narrate the reasoning that led there.

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

- S7 classes: `Foo := new_class(properties = list(...))` - no name string
  as the first arg (breaks `:=`'s inference, silently binds to `parent`
  instead and errors). `s7x::` is always fully-qualified in package code.
- Optional properties: `NA` already satisfies `s7x::class_string`/
  `class_double`/`class_boolean`/`Enum` (has `allow_na = TRUE`) - no
  wrapping needed, **including when the property is simply omitted from a
  constructor call** (verified by `tests/testthat/test-type-defaults.R`;
  this used to be false and broke on omission until a round of `s7x` fixes
  to `new_enum()`/`property_scalar()`/`property_range()`/`property_union()`
  default-value handling). Only optional *object-typed* properties need
  `s7x::property_union(Type, NULL, default = NULL)` - and that literal
  `NULL` really is respected on omission now (`property_union()` used to
  conflate "no `default` arg supplied" with "`default = NULL` supplied
  explicitly" and would deep-default into `Type` instead; fixed).
- `Color` (`R/color.R`) is `r`/`g`/`b`/`a` (four `class_double`), not the
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

## Standing rule from global config

Never write/run ad-hoc inline scripts (`python -c`, `node -e`, etc.) for
file operations or data manipulation, even read-only checks - this
project has been burned by that before. Data-generating R scripts live
under `data-raw/` as real files, reviewed, then run with
`R -q -f data-raw/whatever.R`. One-off `R -q -e` inspection/verification
snippets are fine.
