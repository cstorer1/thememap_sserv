# app/main.R
#renv::install(c("dplyr", "echarts4r", "htmlwidgets", "reactable", "tidyr"))
#renv::snapshot()

box::use(
  shiny[bootstrapPage, moduleServer, NS],
  rhino[rhinos],
)
box::use(
  app/view/chart,
  app/view/table,
)


#' @export
ui <- function(id) {
  ns <- NS(id)

  bootstrapPage(
    table$ui(ns("table")),		
    chart$ui(ns("chart"))
    
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
  data <- rhinos
#  data2 <- rhinos
  table$server("table", data = data)
  chart$server("chart", data = data)
  })
}


