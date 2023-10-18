# app/main.R
#renv::install(c("dplyr", "echarts4r", "htmlwidgets", "reactable", "tidyr"))
#renv::snapshot()

# app/main.R
box::use(
  shiny[...], semantic.dashboard[...],
  rhino[rhinos],
)
box::use(
  app/view/table,
)


#' @export
ui <- function(id) {
  ns <- NS(id)

  bootstrapPage(
    table$ui(ns("table")),		
    fileInput(ns("upload"), NULL, buttonLabel = "Upload...", multiple = TRUE),
    tableOutput(ns("files"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
  data <- rhinos

  table$server("table", data = data)
  output$files <- renderTable(input$upload)
  })
}




