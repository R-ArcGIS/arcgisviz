# The drawing tools are where a map stops being a picture. A shape drawn in
# the browser comes back as an sf object, so the next line of R can do real
# spatial work with it - here, summarising the counties it covers.
devtools::load_all()
library(sf)
library(shiny)
library(calcite)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

ui <- calcite_shell(
  header = calcite_navigation(
    calcite_navigation_logo(slot = "logo", heading = "Drawing on a map")
  ),

  panel_end = calcite_shell_panel(
    width = "m",
    calcite_panel(
      heading = "What the tools produced",

      calcite_block(
        heading = "Inside the shape",
        description = "Counties the drawn polygon covers",
        collapsible = TRUE,
        expanded = TRUE,
        icon_start = "polygon-vertices",
        tableOutput("covered")
      ),

      calcite_block(
        heading = "Measurement",
        description = "Read off the measurement tools",
        collapsible = TRUE,
        expanded = TRUE,
        icon_start = "measure",
        verbatimTextOutput("measured")
      ),

      calcite_block(
        heading = "Edits",
        description = "Features changed in the browser",
        collapsible = TRUE,
        expanded = TRUE,
        icon_start = "pencil",
        verbatimTextOutput("edited")
      )
    )
  ),

  calcite_panel(
    heading = "North Carolina counties",
    arcgisMapOutput("map", height = "calc(100vh - 9rem)")
  )
)

server <- function(input, output, session) {
  # Four tools, all the same add_widget() call. The sketch draws new shapes,
  # the editor changes the layer's own features, and the two measurement
  # components report lengths and areas.
  output$map <- renderArcgisMap({
    arc_map() |>
      add_layer(
        nc,
        color = BIR74,
        palette = "Blues",
        name = "Counties",
        tooltip = c(County = NAME, Births = BIR74)
      ) |>
      add_widget(
        "sketch",
        available_create_tools = c("polygon", "rectangle", "circle"),
        creation_mode = "single"
      ) |>
      add_widget("editor", position = "bottom-right") |>
      add_widget("distance-measurement", position = "top-left") |>
      add_widget("area-measurement", position = "top-left") |>
      add_widget("legend") |>
      as_widget()
  })

  # A drawn shape arrives as an Esri feature set; arc_sf() makes it sf, in
  # longitude/latitude whatever the view was drawn in.
  drawn <- reactive(arc_sf(input$map_sketch))

  output$covered <- renderTable({
    shape <- drawn()
    if (is.null(shape)) {
      return(NULL)
    }

    covered <- st_filter(st_transform(nc, st_crs(shape)), shape)
    if (!nrow(covered)) {
      return(NULL)
    }

    st_drop_geometry(covered[, c("NAME", "BIR74", "SID74")])
  })

  # A measurement is a value and its unit, so it needs no conversion.
  output$measured <- renderPrint({
    result <- input$map_measurement
    if (is.null(result)) {
      return(cat("Start a measurement.\n"))
    }
    str(result)
  })

  # Edits are applied to the browser's copy of the layer. R hears what
  # changed and can write it wherever it likes - nothing is saved for you.
  output$edited <- renderPrint({
    edits <- input$map_edits
    if (is.null(edits)) {
      return(cat("Edit a feature with the editor.\n"))
    }

    cat(
      "added:", length(edits$added),
      " updated:", length(edits$updated),
      " deleted:", length(edits$deleted),
      "\n"
    )
    print(arc_sf(edits))
  })
}

shinyApp(ui, server)
