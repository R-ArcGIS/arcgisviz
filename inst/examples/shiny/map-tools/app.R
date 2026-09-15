# The drawing tools are where a map stops being a picture. A shape drawn in
# the browser comes back as an sf object, so the next line of R can do real
# spatial work with it - here, summarising the counties it covers.
#
#   shiny::runApp(system.file("examples/shiny/map-tools", package = "arcgisviz"))
#
# Four tools, all added with the same add_widget()/add_*() call, and each one
# reports from a different place because that is where the SDK puts the
# result: the sketch has its own events, the editor reports through the
# layer, and the two measurement components have no event at all.
library(arcgisviz)
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
        heading = "The shape itself",
        description = "Read back with arc_sf()",
        collapsible = TRUE,
        icon_start = "freehand-area",
        verbatimTextOutput("drawn")
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
  # The sketch draws new shapes, the editor changes the layer's own features,
  # and the two measurement components report lengths and areas. Client side
  # feature layers are editable, so the editor has something to work on.
  output$map <- renderArcgisMap({
    arc_map() |>
      add_layer(
        nc,
        color = BIR74,
        palette = "Blue 5",
        name = "Counties",
        tooltip = c(County = NAME, Births = BIR74)
      ) |>
      add_sketch(
        tools = c("polygon", "rectangle", "circle"),
        creation_mode = "single"
      ) |>
      add_editor(position = "bottom-right") |>
      add_measurement("distance", position = "top-left") |>
      add_measurement(
        "area",
        position = "top-left",
        unit = "square-kilometers"
      ) |>
      add_legend(position = "bottom-left") |>
      as_widget()
  })

  # A drawn shape arrives as an Esri feature set string; arc_sf() makes it
  # sf, in longitude/latitude whatever the view was drawn in. The view draws
  # in metres, and the next line of R rarely wants that.
  drawn <- reactive(arc_sf(input$map$sketch))

  output$drawn <- renderPrint({
    shape <- drawn()
    if (is.null(shape)) {
      return(cat("Draw something with the sketch tool.\n"))
    }
    print(shape)
    cat("\nCRS:", st_crs(shape)$input, "\n")
  })

  # Real spatial work on a shape that was drawn in a browser.
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
    result <- input$map$measurement
    if (is.null(result)) {
      return(cat("Start a measurement.\n"))
    }
    str(result)
  })

  # Edits are applied to the browser's copy of the layer, and nothing is
  # saved for you. R hears what changed and decides whether to persist it.
  output$edited <- renderPrint({
    edits <- input$map$edits
    if (is.null(edits)) {
      return(cat("Edit a feature with the editor.\n"))
    }

    cat(
      "added:",
      length(edits$added),
      " updated:",
      length(edits$updated),
      " deleted:",
      length(edits$deleted),
      "\n\n"
    )
    # Edited features keep the layer's own CRS, unlike drawn ones.
    print(arc_sf(edits))
  })
}

shinyApp(ui, server)
