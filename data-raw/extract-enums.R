# Pulls every enum out of data-raw/spec-type-registry.json into one
# consolidated view: named top-level enums (their own `definitions.<Name>`
# entry in the spec) plus inline enums found nested inside object
# properties, tuples, and anyOf/oneOf alternatives that don't have their
# own name in the spec. Each inline usage is checked against the named
# enums' value sets so duplicate S7 enum classes aren't generated for the
# same set of values under different property names.
#
# Output: data-raw/spec-enums.json
#   - named_enums: { TypeName: { values, nullable, description } }
#   - inline_enum_usages: [ { path, values, nullable, description, matches_named } ]

library(jsonlite)

registry <- read_json("data-raw/spec-type-registry.json")

is_enum_node <- function(node) {
  is.list(node) && !is.null(node$kind) && identical(node$kind, "enum")
}

# Walks a resolved schema node, recording every enum leaf found (named
# top-level entries are walked too, but as a single-node tree so they're
# picked up as "the enum itself" rather than an inline usage - handled
# separately below via named_enums).
walk_node <- function(node, path, out) {
  if (is.null(node) || !is.list(node)) {
    return(out)
  }

  if (is_enum_node(node)) {
    out[[length(out) + 1]] <- list(
      path = path,
      values = unlist(node$values),
      nullable = isTRUE(node$nullable),
      description = node$description
    )
    return(out)
  }

  kind <- node$kind
  if (identical(kind, "object")) {
    for (nm in names(node$properties)) {
      out <- walk_node(node$properties[[nm]], paste0(path, ".", nm), out)
    }
    return(out)
  }

  if (identical(kind, "tuple")) {
    items <- node$items
    for (i in seq_along(items)) {
      out <- walk_node(items[[i]], paste0(path, "[", i, "]"), out)
    }
    return(out)
  }

  if (identical(kind, "array")) {
    if (!is.null(node$items)) {
      out <- walk_node(node$items, paste0(path, "[]"), out)
    }
    return(out)
  }

  if (kind %in% c("anyOf", "oneOf")) {
    alts <- node$alternatives
    for (i in seq_along(alts)) {
      out <- walk_node(alts[[i]], paste0(path, "<", i, ">"), out)
    }
    return(out)
  }

  # ref, const, primitive, open_object, unknown, not_found: leaves, nothing
  # further to walk.
  out
}

# 1. Named top-level enums: any registry entry whose own kind is "enum".
named_enums <- Filter(is_enum_node, registry)
named_enums <- lapply(named_enums, function(e) {
  list(
    values = unlist(e$values),
    nullable = isTRUE(e$nullable),
    description = e$description
  )
})

# 2. Inline enum usages: walk every top-level type's *nested* structure.
# (Named top-level enums are walked too but immediately hit the
# is_enum_node() check at the root and return as a single entry equal to
# themselves - filter those back out below so they don't duplicate #1.)
all_hits <- list()
for (type_name in names(registry)) {
  all_hits <- walk_node(registry[[type_name]], type_name, all_hits)
}
inline_enum_usages <- Filter(
  function(h) !(h$path %in% names(named_enums)),
  all_hits
)

values_match <- function(a, b) {
  identical(sort(as.character(a)), sort(as.character(b)))
}

inline_enum_usages <- lapply(inline_enum_usages, function(u) {
  match_name <- NULL
  for (nm in names(named_enums)) {
    if (values_match(u$values, named_enums[[nm]]$values)) {
      match_name <- nm
      break
    }
  }
  u$matches_named <- match_name
  u
})

write_json(
  list(named_enums = named_enums, inline_enum_usages = inline_enum_usages),
  "data-raw/spec-enums.json",
  auto_unbox = TRUE,
  pretty = TRUE,
  null = "null"
)

cat("Named enums:", length(named_enums), "\n")
cat("Inline enum usages:", length(inline_enum_usages), "\n")
matched <- sum(vapply(
  inline_enum_usages,
  function(u) !is.null(u$matches_named),
  logical(1)
))
cat("Inline usages matching a named enum's value set:", matched, "\n")
