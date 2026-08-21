# arc_map_proxy() updates a map that is already rendered, without resending
# the features, and the map reports back what the reader did to it.
devtools::load_all()
library(sf)
library(shiny)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
nc$region <- ifelse(st_coordinates(st_centroid(nc))[, 1] > -80, "East", "West")

ui <- fluidPage(
  titlePanel("arcgisviz maps in Shiny"),
  sidebarLayout(
    sidebarPanel(
      selectInput("basemap", "Basemap", c("topo-vector", "satellite", "oceans")),
      sliderInput("births", "Minimum births, 1974", 0, 22000, 0, step = 500),
      checkboxInput("seats", "Show county seats"),
      selectInput("region", "Highlight region", c("None", "East", "West")),
      actionButton("goto", "Zoom to Raleigh")
    ),
    mainPanel(
      arcgisMapOutput("map", height = "460px"),
      fluidRow(
        column(6, h4("Hover"), verbatimTextOutput("hover")),
        column(6, h4("Click"), verbatimTextOutput("click"))
      )
    )
  )
)

server <- function(input, output, session) {
  # Rendered once. Everything after this goes through the proxy, so the
  # counties cross the wire exactly one time.
  output$map <- renderArcgisMap({
    arc_map() |>
      add_layer(
        nc,
        color = BIR74,
        palette = "Orange 5",
        name = "Counties",
        tooltip = c(County = NAME, Births = BIR74, Region = region)
      ) |>
      as_widget()
  })

  # A basemap change carries no data at all.
  observeEvent(input$basemap, {
    arc_map_proxy("map") |>
      set_basemap(input$basemap) |>
      arc_update()
  })

  # A filter re-evaluates the layer's own definition expression in place -
  # no layer is rebuilt and nothing is resent.
  observeEvent(input$births, {
    arc_map_proxy("map") |>
      set_filter(paste("BIR74 >=", input$births), layer = "Counties")
  })

  # A layer added through a proxy must be named; adding it again under the
  # same name replaces it, and remove_layer() takes it back off.
  observeEvent(input$seats, {
    proxy <- arc_map_proxy("map")
    if (input$seats) {
      proxy |>
        add_layer(
          st_centroid(nc),
          palette = "grey20",
          size = 6,
          name = "Seats",
          tooltip = c(County = NAME)
        ) |>
        arc_update()
    } else {
      remove_layer(proxy, "Seats")
    }
  })

  # set_selection() highlights by object id, which is what links a map to a
  # chart drawn from the same rows.
  observeEvent(input$region, {
    ids <- if (input$region == "None") integer() else which(nc$region == input$region)
    arc_map_proxy("map") |>
      set_selection(ids, layer = "Counties")
  })

  # arc_goto() animates, unlike set_view(), which jumps.
  observeEvent(input$goto, {
    arc_map_proxy("map") |>
      arc_goto(center = c(-78.64, 35.78), zoom = 9, duration = 1200)
  })

  # Hovering a feature sends its attributes; the tooltip draws itself.
  output$hover <- renderPrint(input$map_hover)

  # A click reports where, and which feature if one was under the pointer.
  output$click <- renderPrint(input$map_click)
}

shinyApp(ui, server)
