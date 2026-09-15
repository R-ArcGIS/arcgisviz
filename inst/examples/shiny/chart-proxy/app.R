# arc_proxy() updates a chart that is already rendered, without resending the
# data, and the chart reports back what the reader did to it.
#
#   shiny::runApp(system.file("examples/shiny/chart-proxy", package = "arcgisviz"))
#
# ArcProxy subclasses ArcChart, so every set_*() in the package works on a
# proxy with no duplicated code. arc_update() flushes the lot as one message,
# so a pipeline of five setters costs one re-render, not five.
library(arcgisviz)
library(shiny)

penguins <- datasets::penguins


ui <- fluidPage(
  titlePanel("arcgisviz charts in Shiny"),

  sidebarLayout(
    sidebarPanel(
      width = 3,

      h4("Mapping"),
      selectInput("x", "Group by", c("species", "island", "sex")),
      selectInput("y", "Measure", c("body_mass", "flipper_len", "bill_len")),
      selectInput("stat", "Statistic", c("count", "mean", "max", "min", "sd")),
      selectInput("color", "Colour by", c("island", "species", "sex")),

      h4("Layout"),
      selectInput("position", "Position", c("dodge", "stack", "fill")),
      selectInput(
        "legend",
        "Legend",
        c("right", "left", "top", "bottom", "hidden")
      ),
      checkboxInput("flipped", "Flip axes"),

      h4("Filter"),
      textInput("where", NULL, placeholder = "body_mass > 4000"),
      helpText("A SQL where clause. Empty clears it."),

      h4("Act on the chart"),
      actionButton("select", "Select the first 20 rows"),
      actionButton("clear", "Clear selection"),
      actionButton("zoom", "Reset zoom"),
      actionButton("notify", "Show a message"),
      br(),
      br(),
      actionButton("png", "Download PNG"),
      actionButton("csv", "Download CSV")
    ),

    mainPanel(
      width = 9,
      arcgisChartOutput("chart", height = "420px"),

      fluidRow(
        column(4, h4("Selection"), verbatimTextOutput("selection")),
        column(4, h4("Legend"), verbatimTextOutput("legend_event")),
        column(4, h4("Axes"), verbatimTextOutput("axes"))
      ),
      fluidRow(
        column(4, h4("Series order"), verbatimTextOutput("order")),
        column(4, h4("Status"), verbatimTextOutput("status")),
        column(4, h4("Errors"), verbatimTextOutput("error"))
      )
    )
  )
)


server <- function(input, output, session) {
  # Rendered once. Everything after this goes through the proxy, so the 344
  # penguins cross the wire exactly one time.
  output$chart <- renderArcgisChart({
    arc_bar(penguins, species) |>
      set_stat("count") |>
      set_color(island) |>
      as_widget()
  })

  # The chart is a plain value, so it can be rebuilt from inputs like any
  # other reactive. !!rlang::sym() turns a string input back into a mapping.
  chart <- reactive({
    chart <- arc_chart(penguins) |>
      set_type("bar") |>
      set_x(!!rlang::sym(input$x)) |>
      set_y(!!rlang::sym(input$y)) |>
      set_stat(input$stat) |>
      set_color(!!rlang::sym(input$color)) |>
      set_position(input$position) |>
      set_flipped(input$flipped) |>
      set_labs(
        title = "Palmer penguins",
        subtitle = paste0(input$stat, "(", input$y, ") by ", input$x)
      )

    # Colouring by x does not group the chart, so there would be nothing for
    # a legend to key and asking for one is an error.
    if (input$color == input$x) {
      return(chart)
    }
    if (input$legend == "hidden") {
      set_legend(chart, visible = FALSE)
    } else {
      set_legend(chart, position = input$legend, title = input$color)
    }
  })

  # One message per flush, however many set_*() calls went into it.
  observeEvent(chart(), {
    arc_proxy("chart", chart()) |> arc_update()
  })

  # A filter never rebuilds the model - the chart requeries the layer it is
  # already holding, which is the cheapest interaction available.
  observeEvent(input$where, {
    arc_proxy("chart", chart()) |>
      set_filter(where = if (nzchar(input$where)) input$where else NULL)
  })

  # Selection by object id, which for a data frame is the row number.
  observeEvent(input$select, {
    arc_proxy("chart", chart()) |> set_selection(1:20)
  })

  observeEvent(input$clear, {
    arc_proxy("chart", chart()) |> arc_clear_selection()
  })

  observeEvent(input$zoom, {
    arc_proxy("chart", chart()) |> arc_reset_zoom()
  })

  # The chart's own info panel, not a Shiny notification.
  observeEvent(input$notify, {
    arc_proxy("chart", chart()) |>
      arc_notify("Rendered from R, updated over the proxy.", heading = "Hello")
  })

  # Both exports download in the reader's browser.
  observeEvent(input$png, {
    arc_proxy("chart", chart()) |> arc_export_image("png")
  })

  observeEvent(input$csv, {
    arc_proxy("chart", chart()) |> arc_export_csv()
  })

  # Every event lands on one input, named by the output id, with the event as
  # a field on it - input$chart$selection, never input$chart_selection. The
  # object accumulates, so a status update does not wipe out the selection.
  output$selection <- renderPrint(str(input$chart$selection))
  output$legend_event <- renderPrint(str(input$chart$legend))
  output$axes <- renderPrint(str(input$chart$axes))
  output$order <- renderPrint(str(input$chart$series_order))
  output$status <- renderPrint(str(input$chart$status))
  output$error <- renderPrint(str(input$chart$error))
}

shinyApp(ui, server)
