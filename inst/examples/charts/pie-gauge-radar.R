library(arcgisviz)
library(dplyr)

penguins <- datasets::penguins


# --- pie: one slice per category -------------------------------------------
arc_pie(penguins, species)

# --- pie: values you already have ------------------------------------------
arc_pie(data.frame(part = c("a", "b", "c"), n = c(5, 3, 2)), part, n)

# --- pie: any other statistic ----------------------------------------------
arc_chart(penguins) |>
  set_type("pie") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_pie(labels = c("category", "value"))

# --- pie: slice labels -----------------------------------------------------
arc_pie(penguins, species, labels = "percent")
arc_pie(penguins, species, labels = c("category", "percent"))
arc_pie(penguins, species, labels = c("category", "value", "percent"))

# --- pie: a doughnut -------------------------------------------------------
arc_pie(penguins, species, hole = 55, labels = c("category", "percent")) |>
  set_labs(title = "Penguins by species")

# --- pie: labels outside the slices ----------------------------------------
arc_pie(penguins, island, hole = 40, labels = "category", inside = FALSE)

# --- pie: colour and a legend ----------------------------------------------
arc_pie(penguins, island) |>
  set_color(island, palette = "Purple 1") |>
  set_legend(position = "left", title = "Island")


# --- radar: one series -----------------------------------------------------
arc_radar(penguins, species, body_mass) |>
  set_stat("mean")

# --- radar: a zero baseline ------------------------------------------------
arc_radar(penguins, species, body_mass) |>
  set_stat("mean") |>
  set_axis("y", limits = c(0, NA))

# --- radar: grouped --------------------------------------------------------
arc_chart(penguins) |>
  set_type("radar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(sex) |>
  set_axis("y", limits = c(0, NA)) |>
  set_legend(title = "Sex")

# --- radar: variable importance --------------------------------------------
complete <- penguins |>
  select(body_mass, species, island, sex, bill_len, bill_dep, flipper_len) |>
  tidyr::drop_na()

linear <- drop1(lm(body_mass ~ ., data = complete), test = "F")[-1, ]
tree <- rpart::rpart(body_mass ~ ., data = complete)

importance <- bind_rows(
  tibble(
    model = "Linear model",
    variable = rownames(linear),
    score = linear[["F value"]]
  ),
  tibble(
    model = "Regression tree",
    variable = names(tree$variable.importance),
    score = unname(tree$variable.importance)
  )
) |>
  group_by(model) |>
  mutate(score = 100 * score / max(score)) |>
  ungroup()

arc_radar(importance, variable, score, area = TRUE, point_size = 8) |>
  set_stat("mean") |>
  set_color(model, palette = c("darkorange", "purple")) |>
  set_axis("y", limits = c(0, 100)) |>
  set_legend(position = "bottom") |>
  set_labs(title = "Variable importance")

# --- radar: axis titles ----------------------------------------------------
arc_radar(penguins, island, flipper_len) |>
  set_stat("mean") |>
  set_axis("y", limits = c(0, NA)) |>
  set_labs(title = "Mean flipper length by island")


# --- gauge: one statistic --------------------------------------------------
arc_gauge(penguins, body_mass, stat = "mean")

arc_gauge(penguins, flipper_len, stat = "max")
arc_gauge(penguins, bill_len, stat = "min")

# --- gauge: a fixed scale --------------------------------------------------
arc_gauge(penguins, flipper_len, stat = "max") |>
  set_axis("x", limits = c(0, 250)) |>
  set_labs(title = "Longest flipper")

# --- gauge: one row --------------------------------------------------------
arc_gauge(penguins, body_mass, feature = 1)
arc_gauge(penguins, body_mass, feature = 344)

# --- gauge: dial shape -----------------------------------------------------
arc_gauge(penguins, bill_len, stat = "mean") |>
  set_gauge(hole = 70, angles = c(-180, 0), needle = FALSE)

arc_gauge(penguins, body_mass, stat = "mean") |>
  set_gauge(angles = c(-210, 30), hole = 40) |>
  set_axis("x", limits = c(2000, 7000)) |>
  set_labs(title = "Mean body mass (g)")

# --- gauge: set_color() errors ---------------------------------------------
try(arc_gauge(penguins, body_mass, stat = "mean") |> set_color(species))
