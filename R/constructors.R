#' @include types-renderer.R
NULL

# The user-facing `new_*()` constructors. They exist so that building a
# renderer never requires naming an S7 class or an esri-prefixed enum value:
# a friendly `type`, then that type's own properties.

# Friendly names, kebab-case and without the REST prefixes, mapped to the
# class each one builds. The class supplies its own `type` discriminator.
renderer_classes <- list(
  simple = ISimpleRenderer,
  `unique-value` = IUniqueValueRenderer
)

symbol_classes <- list(
  marker = ISimpleMarkerSymbol,
  fill = ISimpleFillSymbol,
  line = ISimpleLineSymbol
)

# A marker has no "solid" - its styles are shapes - so the default that
# stands in for "just draw it" differs per family.
symbol_styles <- list(
  marker = list(enum = SimpleMarkerSymbolStyle, default = "circle"),
  fill = list(enum = SimpleFillSymbolStyle, default = "solid"),
  line = list(enum = SimpleLineSymbolStyle, default = "solid")
)

# "esriSFSBackwardDiagonal" -> "backward-diagonal". Derived from the enum's
# own variants, so a style added to the spec needs no table here.
style_names <- function(enum) {
  variants <- enum()@variants
  friendly <- sub("^esriS[LFM]S", "", variants)
  friendly <- gsub("([a-z0-9])([A-Z])", "\\1-\\2", friendly)
  rlang::set_names(variants, tolower(friendly))
}

# `...` must be named: a positional value would land on the first property,
# which is `type`, and quietly replace the discriminator.
check_helper_args <- function(args, cls, label, call) {
  unnamed <- rlang::names2(args) == ""
  if (any(unnamed)) {
    cli::cli_abort(
      c(
        "Every argument in {.arg ...} must be named.",
        "x" = "Argument{?s} {.val {which(unnamed)}} {?is/are} not."
      ),
      call = call
    )
  }

  known <- names(S7::props(cls()))
  unknown <- setdiff(names(args), known)
  if (!rlang::is_empty(unknown)) {
    cli::cli_abort(
      c(
        "{.arg {unknown}} {?is not a/are not} propert{?y/ies} of a
         {.val {label}}.",
        "i" = "It takes {.arg {setdiff(known, 'type')}}."
      ),
      call = call
    )
  }

  invisible(args)
}

# A colour is written the way it is everywhere else in this package - a name
# or a hex string - and becomes a Color on the way in.
coerce_color <- function(args, call) {
  if (rlang::is_null(args$color) || S7::S7_inherits(args$color, Color)) {
    return(args)
  }
  args$color <- parse_color(args$color, arg = "color", call = call)[[1]]
  args
}

coerce_style <- function(args, type, call) {
  spec <- symbol_styles[[type]]
  if (S7::S7_inherits(args$style, s7x::Enum)) {
    return(args)
  }

  styles <- style_names(spec$enum)
  wanted <- if (rlang::is_null(args$style)) {
    spec$default
  } else {
    rlang::arg_match0(args$style, names(styles), error_call = call)
  }
  args$style <- spec$enum(unname(styles[[wanted]]))
  args
}

legend_orders <- c(ascending = "ascendingValues", descending = "descendingValues")

#' Describe a renderer in the legend
#'
#' Names and orders what a renderer or a colour ramp contributes to the map's
#' legend. Pass the result as the `legendOptions` of [new_renderer()] or of a
#' colour visual variable.
#'
#' A continuous ramp is otherwise unlabelled, so `title` is the usual reason
#' to reach for this.
#'
#' @param title default `NULL`. Defines the text naming this renderer or ramp.
#' @param visible default `NULL`. Defines whether it appears in the legend at
#'   all. Has no effect under a `"unique-value"` renderer, which the spec does
#'   not allow it on.
#' @param order default `NULL`. Defines which end comes first, either
#'   `"ascending"` or `"descending"`.
#' @return An [ILegendOptions].
#' @examples
#' new_legend_options(title = "Births, 1974", order = "descending")
#' @export
new_legend_options <- function(title = NULL, visible = NULL, order = NULL) {
  call <- rlang::caller_env()

  # Omitted, not NA: an unset property already defaults to NA and drops out
  # of the wire format, and an enum cannot be constructed from a logical NA.
  args <- list()
  if (!rlang::is_null(title)) {
    args$title <- title
  }
  if (!rlang::is_null(visible)) {
    args$showLegend <- isTRUE(visible)
  }
  if (!rlang::is_null(order)) {
    order <- rlang::arg_match0(order, names(legend_orders), error_call = call)
    args$order <- ILegendOptionsOrder(unname(legend_orders[[order]]))
  }

  rlang::exec(ILegendOptions, !!!args)
}

#' Create a renderer
#'
#' Builds a renderer to hand to [add_renderer()]. `type` picks which kind and
#' `...` sets that kind's properties, so this is one function instead of
#' remembering which class goes with which symbology.
#'
#' A `"simple"` renderer draws every feature the same way, optionally varying
#' colour by a `colorInfo` visual variable. A `"unique-value"` renderer draws
#' one symbol per value of a field.
#'
#' @param type default `"simple"`. Defines which renderer to build, either
#'   `"simple"` or `"unique-value"`.
#' @param ... Defines the renderer's properties, all named. See
#'   [ISimpleRenderer] and [IUniqueValueRenderer] for what each kind takes.
#' @return An [ISimpleRenderer] or an [IUniqueValueRenderer].
#' @examples
#' new_renderer("simple", symbol = new_symbol("marker", color = "red"))
#'
#' new_renderer("unique-value", field1 = "species")
#' @export
new_renderer <- function(type = "simple", ...) {
  call <- rlang::caller_env()
  type <- rlang::arg_match0(type, names(renderer_classes), error_call = call)
  cls <- renderer_classes[[type]]

  args <- rlang::list2(...)
  check_helper_args(args, cls, paste(type, "renderer"), call)
  rlang::exec(cls, !!!args)
}

#' Create a symbol
#'
#' Builds the symbol a renderer draws with. `type` follows the geometry -
#' `"marker"` for points, `"line"` for lines, `"fill"` for polygons - and
#' `...` sets that symbol's properties.
#'
#' `color` takes a colour name or hex string rather than a [Color], and
#' `style` takes a friendly name such as `"solid"` or `"backward-diagonal"`
#' rather than an esri-prefixed enum value. `style` defaults to `"solid"`.
#'
#' @param type default `"marker"`. Defines which symbol to build, one of
#'   `"marker"`, `"fill"`, or `"line"`.
#' @param ... Defines the symbol's properties, all named. See
#'   [ISimpleMarkerSymbol], [ISimpleFillSymbol], and [ISimpleLineSymbol].
#' @return An [ISimpleMarkerSymbol], [ISimpleFillSymbol], or
#'   [ISimpleLineSymbol].
#' @examples
#' new_symbol("marker", color = "steelblue", size = 8)
#'
#' new_symbol("fill",
#'   color = "#b8282899",
#'   outline = new_symbol("line", color = "white", width = 0.5)
#' )
#' @export
new_symbol <- function(type = "marker", ...) {
  call <- rlang::caller_env()
  type <- rlang::arg_match0(type, names(symbol_classes), error_call = call)
  cls <- symbol_classes[[type]]

  args <- rlang::list2(...)
  check_helper_args(args, cls, paste(type, "symbol"), call)
  args <- coerce_style(coerce_color(args, call), type, call)
  rlang::exec(cls, !!!args)
}
