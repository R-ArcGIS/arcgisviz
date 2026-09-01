# Shiny integration

Design for driving a rendered chart from the server without re-sending the
data, and for reading what the user did to it back into R. Nothing here is
built yet.

Everything below comes from `@arcgis/charts-components@5.1.17`'s own
declarations:

- `dist/components/arcgis-chart/customElement.d.ts` - the element's
  properties, methods, and events.
- `dist/model/**/*.d.ts` - the `ChartModel` accessors, which are what make
  an incremental update possible.
- `dist/utils/components/event-payloads.d.ts` and
  `dist/utils/misc/interfaces.d.ts` - the event payload shapes.

## The central fact: the model has live accessors

`createModel()` returns a `ChartModel`, and that model exposes the mapping as
plain accessors. Writing one re-derives the series and its query and
re-renders, without a new `createModel()` call and without the layer being
rebuilt. **This is what makes a client-side `set_x()` possible**, and it is
the whole reason a proxy is worth building rather than just re-rendering the
widget.

The accessor names are not uniform across chart types, so the proxy has to
map our vocabulary onto them per type. This belongs in `chart_type_map`
alongside `config_class`/`splits`/`stacks`, as a `model_fields` entry.

| our name | bar, line, combo, heat | scatter | histogram | box plot |
|---|---|---|---|---|
| `x` | `xAxisField` | `xAxisField` | `numericField` | `category` |
| `y` | `numericFields` (`string[]`) | `yAxisField` | none | `numericFields`, **read only** |
| `stat` | `aggregationType` | none | none | none |
| split | `splitByField` | none | none | `splitByField` |
| `position` | `stackedType` (bar, line) | none | none | none |
| `flipped` | `rotated` | none | none | `rotated` |

`SerialChartModel` (`dist/model/serial-chart-model/serial-chart-model.d.ts`)
backs bar, line, combo, and heat. Scatter, histogram, and box plot each
compose `ChartModel` with their own mixins, which is why `rotated`
(`WithRotatedState`) reaches box plot but not scatter or histogram.

Shared across every model, from `ChartModel`'s own mixin list: `config`,
`layer`, `titleText`, `subtitleText`, `descriptionText`, `chartRenderer`,
`colorMatch`, `backgroundColor`, `seriesVisibility`, `splitByValues`
(a getter), `setDataFilters()`, and the `ModelWithLegend` block
(`legendVisibility`, `legendPosition`, `legendTitleText`, ...).

## Architecture

The widget factory keeps three things in its closure: the `<arcgis-chart>`
element, the `iLayer` it was built from, and the fully merged config. It
returns them on the instance object so `HTMLWidgets.find("#id")` can reach
them from a message handler.

One custom message handler, `"arcgisviz-chart"`, with a `method` discriminator:

| `method` | what it does | cost |
|---|---|---|
| `model` | writes accessors on the live `ChartModel` | re-derives the query, no layer rebuild |
| `element` | writes accessors on the `<arcgis-chart>` element | usually no re-query at all |
| `call` | invokes an element method | varies |
| `config` | `deepMerge`es a sparse `WebChart` over the stored config and calls `createModel()` again | full model rebuild, still no data re-send |
| `data` | replaces `iLayer`, then as `config` | re-sends the data |

`config` is the escape hatch for the properties with no accessor
(`set_axis()`'s `valueFormat`, most of `set_color()`'s renderer detail). It
reuses `deepMerge()` and the stored config, so it costs a model rebuild but
never re-sends the layer.

Writes coalesce on their own: `ChartModelBase` has `asyncUpdatesPromise` and
`update()`, and every message from one Shiny flush lands in the same JS task.
So the proxy can send one message per `set_*()` call the way leaflet does,
with no batching layer.

## R surface

`arc_proxy(id, session = shiny::getDefaultReactiveDomain())` returns an
`ArcProxy`. The existing `set_*()` functions branch on it internally rather
than becoming S7 generics - they use `rlang::ensym()`, and a generic would
have to thread `...` through to keep that working. A proxy has no `@data`,
so `check_column()` cannot validate the column; `arcgisRuntimeError` (below)
surfaces a bad field name instead.

```r
observeEvent(input$group_by, {
  arc_proxy("chart") |>
    set_x(!!sym(input$group_by)) |>
    set_color(species)
})
```

New functions this needs:

| function | mechanism | notes |
|---|---|---|
| `arc_proxy()` | - | the handle |
| `set_filter()` | element `runtimeDataFilters` | a `where` clause, applied client side. **The cheapest interaction there is**: no model rebuild, no data re-send |
| `set_legend()` | `WebChart$legend`, flushed by `arc_update()` | an `ArcChart` setter, not a proxy method - the model's `legendVisibility`/`legendPosition`/`legendTitleText` accessors write the same `_config`, so one property covers both paths |
| `set_selection()` | element `selectionData` | push a selection in, as `selectionOIDs` |
| `set_data()` | `data` message | swap the data frame under a live chart |
| `arc_refresh()` | `refresh({updateData, resetAxesBounds})` | |
| `arc_reset_zoom()` | `resetZoom()` | XY charts only |
| `arc_clear_selection()` | `clearSelection()` | |
| `arc_export_image()` | `exportAsImage(format)` | `"png"`, `"jpeg"`, `"svg"`. Downloads in the browser |
| `arc_export_csv()` | `exportAsCSV(options)` | not supported for scatterplots |
| `arc_notify()` | `notify(message, heading)` | writes into the chart's own info modal |

`set_filter()` maps onto `WebChartDataFilters`, which is
`Pick<WebChartQuery, "distance" | "gdbVersion" | "geometry" | "objectIds" |
"spatialRelationship" | "timeExtent" | "units" | "where">`
(`web-chart.d.ts:591`) and is already modeled in `R/types-webchart.R`. Of
those, `where` and `objectIds` are the two that matter from R. There are two
places to put it: the element's `runtimeDataFilters` (transient, what a
proxy should use) and the model's `setDataFilters()` (persists into
`config.dataFilters`, what `ArcChart` should use).

## Events to subscribe to

Named for `arcgisChartOutput("chart")`. Each is `Shiny.setInputValue` on the
event, `priority: "event"` where a repeat of the same value must still fire.

| input | event | payload |
|---|---|---|
| `input$chart_selection` | `arcgisSelectionComplete` | `SelectionCompletePayload`. The one that matters: click or brush a chart, filter a table |
| `input$chart_legend` | `arcgisLegendItemVisibilityChange` | which series the user toggled off |
| `input$chart_axes` | `arcgisAxesMinMaxChange` | computed bounds, so it also reports zoom |
| `input$chart_colors` | `arcgisSeriesColorChange` | the colours actually assigned per series, which is how R could draw its own legend |
| `input$chart_series_order` | `arcgisSeriesOrder` | series ids after `orderOptions` ran |
| `input$chart_status` | `arcgisUpdateComplete` | `ValidationStatus`. Fires when a render finishes, so it is also the "chart is ready" signal |
| `input$chart_error` | `arcgisRuntimeError`, `arcgisDataProcessError`, `arcgisBadDataWarningRaise` | one input carrying a `kind`, rather than three |
| `input$chart_data` | `arcgisDataProcessComplete` | the whole processed dataset. Opt-in only |

Deliberately not subscribed:

- `arcgisConfigChange` fires on our own writes, so it would feed back into
  the server on every proxy call.
- `arcgisChartNotFoundWarning` only applies to `chartIndex`, which we never
  set.
- `arcgisInvalidConfigWarningRaise` is deprecated since 5.1.
- `arcgisDataFetchComplete` is pie charts only.
- `arcgisNoRenderPropChange` is internal plumbing.

Three things will bite in the binding:

1. `SelectionData$selectionIndexes` is a JS `Map`
   (`utils/misc/interfaces.d.ts`), which `JSON.stringify` renders as `{}`.
   Convert with `Object.fromEntries()` first.
2. Most payloads carry `model`, the whole `ChartModel`. It is circular and
   must be stripped before `setInputValue`.
3. Object ids are only computed when `returnSelectionOIDs` is `true`
   (default `false`, `customElement.d.ts:1276`), and indexes only when
   `returnSelectionIndexes` is. Set both on the element at render time or
   the selection payload arrives empty.

## Order to build it

1. `arc_proxy()` plus the message handler, with `config` as the only method.
   Correct but slow, and everything else is an optimisation of it.
2. `model` method plus `chart_type_map$model_fields`, then route `set_x()`,
   `set_y()`, `set_stat()`, `set_position()`, `set_flipped()` through it.
3. `arcgisSelectionComplete` and `arcgisUpdateComplete` as inputs. Selection
   is the feature that makes a chart worth putting in Shiny at all.
4. `set_filter()`, both halves.
5. The remaining events and the `call` verb.

`shiny` needs adding to `Suggests`, and the examples want an
`inst/examples/` directory following `{calcite}`'s convention rather than
`dev/`.
