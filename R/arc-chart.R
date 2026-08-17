# Public, user-facing chart-building API. Wraps the internal S7 type layer
# (R/types-*.R) - none of those classes, or their s7x::Enum values, are
# meant to be constructed or referenced by users of this package. Friendly
# values here are kebab-case with no spec-internal prefixes ("side-by-side",
# not "sideBySide"; "bar", not "barChart"/"barSeries") and get translated to
# the exact spec values internally.
#
# Core pipe: arc_chart(.data) |> set_type() |> set_x() |> set_y() |> set_stat()
#
# `ArcChart` holds the mapping, not a WebChart: under aggregation the series'
# `y` is the outStatisticFieldName while onStatisticField is the source
# column, so the config can't be built until both are known.

library(S7)

#' ArcChart
#'
#' @section Properties:
#' `@webchart` is computed from the mapping, not stored - assigning to it
#' has no effect.
#' @name ArcChart
#' @export
ArcChart <- new_class(
  "ArcChart",
  properties = list(
    data = S7::class_any,
    chart_type = s7x::class_string,
    x = s7x::class_string,
    y = s7x::class_string,
    stat = s7x::class_string,
    labs = class_list,
    webchart = S7::new_property(getter = function(self) build_webchart(self))
  )
)

# friendly kebab/plain type name -> {model_type (ModelTypes value, used to
# build the client-side defaults), series_type (the series' own `type`
# discriminator), series_class (which WebChart*Series S7 class to build),
# aggregates (whether the series honours `stat` at all)}
chart_type_map <- list(
  bar = list(
    model_type = "barChart",
    series_type = "barSeries",
    series_class = WebChartBarChartSeries,
    aggregates = TRUE
  ),
  scatter = list(
    model_type = "scatterplot",
    series_type = "scatterSeries",
    series_class = WebChartScatterplotSeries,
    aggregates = FALSE
  ),
  line = list(
    model_type = "lineChart",
    series_type = "lineSeries",
    series_class = WebChartLineChartSeries,
    aggregates = TRUE
  )
)

# friendly stat -> IStatisticDefinition$statisticType. "identity" is absent
# on purpose: it means send no outStatistics at all, which is what ga()
# (dist/chunks/index2.js:593) keys BarAndLineNoAggregation off.
stat_map <- c(
  count = "count",
  sum = "sum",
  mean = "avg",
  min = "min",
  max = "max",
  sd = "stddev",
  var = "var"
)

#' Start a chart
#'
#' @param .data A data frame (or similar) the chart's fields will come from.
#' @return An `ArcChart`. Pipe it into [set_type()] before [set_x()]/[set_y()].
#' @export
arc_chart <- function(.data) {
  ArcChart(data = .data)
}

#' Set a chart's type
#'
#' @param chart An `ArcChart`, from [arc_chart()].
#' @param type One of `"bar"`, `"scatter"`, `"line"`.
#' @return `chart`, with its series type set.
#' @export
set_type <- function(chart, type) {
  chart@chart_type <- rlang::arg_match0(type, names(chart_type_map))
  chart
}

check_chart_type_set <- function(chart, call = rlang::caller_env()) {
  if (is.na(chart@chart_type)) {
    cli::cli_abort(
      c(
        "{.fn set_type} must be called first.",
        "i" = "It decides which series {.arg x}, {.arg y} and {.arg stat}
               are set on."
      ),
      call = call
    )
  }
}

check_column <- function(chart, col, arg, call = rlang::caller_env()) {
  cols <- names(chart@data)
  if (rlang::is_null(chart@data) || col %in% cols) {
    return(invisible(col))
  }

  cli::cli_abort(
    c(
      "{.arg {arg}} must be a column in {.arg .data}.",
      "x" = "Column {.field {col}} not found.",
      "i" = "{.arg .data} has {length(cols)} column{?s}: {.field {cols}}."
    ),
    call = call
  )
}

#' Map a column to a chart's x/y field
#'
#' @param chart An `ArcChart`, from [arc_chart()] with [set_type()] already
#'   called.
#' @param x,y A bare column name from `chart`'s data (tidy eval).
#' @return `chart`, with the field mapping set.
#' @export
set_x <- function(chart, x) {
  check_chart_type_set(chart)
  col <- rlang::as_string(rlang::ensym(x))
  check_column(chart, col, "x")
  chart@x <- col
  chart
}

#' @rdname set_x
#' @export
set_y <- function(chart, y) {
  check_chart_type_set(chart)
  col <- rlang::as_string(rlang::ensym(y))
  check_column(chart, col, "y")
  chart@y <- col
  chart
}

#' Set a chart's statistical transformation
#'
#' How `y` is derived from the data. `"identity"` plots `y` verbatim, one mark
#' per row; every other value aggregates `y` grouped by `x`. `"count"` needs
#' no `y` - it counts rows per `x`.
#'
#' Bar and line charts only; scatterplots ignore it.
#'
#' @param chart An `ArcChart`, from [arc_chart()] with [set_type()] already
#'   called.
#' @param stat One of `"identity"`, `"count"`, `"sum"`, `"mean"`, `"min"`,
#'   `"max"`, `"sd"`, `"var"`.
#' @return `chart`, with its stat set.
#' @export
set_stat <- function(chart, stat) {
  check_chart_type_set(chart)
  chart@stat <- rlang::arg_match0(stat, c("identity", names(stat_map)))
  chart
}

# The series' `y` has to name the aggregate's output field, not the source
# column - the query engine returns the former. Naming follows the SDK's own
# `${statisticType}_${field}_0` convention (dist/chunks/index.js, $e()).
series_aggregation <- function(chart, stat, call = rlang::caller_env()) {
  if (identical(stat, "count")) {
    on_field <- oid_field
  } else {
    if (is.na(chart@y)) {
      cli::cli_abort(
        c(
          "{.fn set_y} is required when {.arg stat} is {.val {stat}}.",
          "i" = "{.val count} is the only stat that needs no {.arg y}."
        ),
        call = call
      )
    }
    on_field <- chart@y
  }
  out_field <- toupper(sprintf("%s_%s_0", stat_map[[stat]], on_field))

  list(
    y = out_field,
    query = WebChartSeriesQuery(
      # I() keeps the spec's string[] - auto_unbox would emit a bare string.
      groupByFieldsForStatistics = I(chart@x),
      outStatistics = list(
        IStatisticDefinition(
          statisticType = IStatisticDefinitionStatisticType(stat_map[[stat]]),
          onStatisticField = on_field,
          outStatisticFieldName = out_field
        )
      )
    )
  )
}

# An omitted label leaves the model's default alone, a string overrides it,
# and NULL removes it. NULL can't be stored in a list without deleting the
# key, so a removed label is held as "" - which is also how it goes over the
# wire, since the client's own empty labels are empty strings.
lab_keep <- structure(list(), class = "arcgisviz_lab_keep")

lab_value <- function(value, arg, call = rlang::caller_env()) {
  if (rlang::is_null(value)) {
    return("")
  }
  if (!rlang::is_string(value)) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must be a single string or {.code NULL}.",
        "x" = "You supplied {.obj_type_friendly {value}}.",
        "i" = "{.code NULL} removes the label; omit {.arg {arg}} to keep the
               default."
      ),
      call = call
    )
  }
  value
}

#' Set a chart's labels
#'
#' Overrides the text a chart labels itself with. Omitting an argument leaves
#' that label as it is; passing a string sets it, and passing `NULL` removes
#' it. `x` and `y` default to the mapped column names.
#'
#' @param chart An `ArcChart`, from [arc_chart()].
#' @param ... These dots are for future extensions and must be empty.
#' @param title,subtitle,caption Chart-level text. `caption` is rendered as
#'   the chart's footer. All three are absent unless set.
#' @param x,y Axis titles. These also label the values in a tooltip.
#' @return `chart`, with its labels set.
#' @export
set_labs <- function(
  chart,
  ...,
  title = lab_keep,
  subtitle = lab_keep,
  caption = lab_keep,
  x = lab_keep,
  y = lab_keep
) {
  rlang::check_dots_empty()

  supplied <- list(
    title = title,
    subtitle = subtitle,
    caption = caption,
    x = x,
    y = y
  )
  supplied <- supplied[
    !vapply(
      supplied,
      inherits,
      logical(1),
      "arcgisviz_lab_keep"
    )
  ]

  labs <- chart@labs
  for (arg in names(supplied)) {
    labs[[arg]] <- lab_value(supplied[[arg]], arg)
  }
  chart@labs <- labs
  chart
}

chart_text <- function(text) {
  WebChartText(
    type = "chartText",
    content = WebChartTextSymbol(type = "esriTS", text = text)
  )
}

# Chart-level labels are absent by default, so a removed one is just unset -
# as_vector() nulls the title out to delete the client's own default.
chart_titled <- function(text) {
  if (rlang::is_null(text) || !nzchar(text)) {
    return(NULL)
  }
  chart_text(text)
}

# Tooltips label each value with the axis title, falling back to the field
# alias only when that title is empty (customElement.js:10170) - and the
# model's defaults are the localized "X-axis"/"Count", so leaving them in
# place mislabels both the axis and the tooltip.
axis_titled <- function(text) {
  # Nothing mapped to title the axis with, so leave those defaults alone.
  if (is.na(text)) {
    return(WebChartAxis())
  }

  # A removed label has to blank the default rather than be dropped, and an
  # invisible title reserves no height (customElement.js:12053).
  if (!nzchar(text)) {
    return(WebChartAxis(
      title = WebChartText(
        type = "chartText",
        visible = FALSE,
        content = WebChartTextSymbol(type = "esriTS", text = "")
      )
    ))
  }

  WebChartAxis(title = chart_text(text))
}

# NULL until set_type() has run - as_widget() reports that as an error.
build_webchart <- function(chart) {
  if (is.na(chart@chart_type)) {
    return(NULL)
  }
  spec <- chart_type_map[[chart@chart_type]]
  stat <- if (is.na(chart@stat)) "identity" else chart@stat
  aggregating <- spec$aggregates && stat != "identity"

  agg <- if (aggregating) {
    series_aggregation(chart, stat)
  } else {
    list(y = chart@y, query = NULL)
  }

  y_label <- if (!aggregating) {
    chart@y
  } else if (identical(stat, "count")) {
    "count"
  } else {
    sprintf("%s(%s)", stat, chart@y)
  }

  labs <- chart@labs
  axis_lab <- function(lab, mapped) if (rlang::is_null(lab)) mapped else lab

  WebChart(
    version = "25.1.0",
    type = "chart",
    title = chart_titled(labs$title),
    subtitle = chart_titled(labs$subtitle),
    footer = chart_titled(labs$caption),
    axes = list(
      axis_titled(axis_lab(labs$x, chart@x)),
      axis_titled(axis_lab(labs$y, y_label))
    ),
    series = list(
      spec$series_class(
        type = spec$series_type,
        id = "series1",
        name = "series1",
        x = chart@x,
        y = agg$y,
        query = agg$query
      )
    )
  )
}

#' Bar chart
#'
#' Counts rows per `x`. Use [arc_col()] to plot values you have already
#' summarised, or [set_stat()] for any other aggregation.
#'
#' @inheritParams arc_chart
#' @param x A bare column name from `.data` (tidy eval).
#' @return An `ArcChart`.
#' @export
arc_bar <- function(.data, x) {
  arc_chart(.data) |> set_type("bar") |> set_x({{ x }}) |> set_stat("count")
}

#' Column chart
#'
#' Plots `y` verbatim, one bar per row.
#'
#' @inheritParams arc_chart
#' @param x,y Bare column names from `.data` (tidy eval).
#' @return An `ArcChart`.
#' @export
arc_col <- function(.data, x, y) {
  arc_chart(.data) |> set_type("bar") |> set_x({{ x }}) |> set_y({{ y }})
}

#' Scatterplot
#'
#' @inheritParams arc_col
#' @export
arc_scatter <- function(.data, x, y) {
  arc_chart(.data) |> set_type("scatter") |> set_x({{ x }}) |> set_y({{ y }})
}

#' Line chart
#'
#' @inheritParams arc_col
#' @export
arc_line <- function(.data, x, y) {
  arc_chart(.data) |> set_type("line") |> set_x({{ x }}) |> set_y({{ y }})
}
