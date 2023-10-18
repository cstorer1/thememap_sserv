# app/main.R
#renv::install(c("dplyr", "echarts4r", "htmlwidgets", "reactable", "tidyr"))
#renv::snapshot()

box::use(
  shiny[bootstrapPage, NS, moduleServer],
    rhino[rhinos],
)
box::use(
  app/view/upload,
  app/view/table,
)


#' @export
ui <- function(id) {
  ns <- NS(id)

  bootstrapPage(
    table$ui(ns("table")),
    upload$ui(ns("upload"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
  data <- rhinos

  table$server("table", data = data)
  upload$server("upload")
  })
}


