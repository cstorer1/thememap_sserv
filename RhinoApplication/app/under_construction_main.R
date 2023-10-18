# app/main.R

#box::use(
#  shiny[bootstrapPage, moduleServer, NS],
#  rhino[rhinos],
#)
box::use( shiny[...], rhino[rhinos] )

box::use(
  app/view/chart,
  app/view/table,
  app/view/upload,
)


#' @export
ui <- function(id) {
  ns <- NS(id)

  bootstrapPage(
    table$ui(ns("table")),		
    chart$ui(ns("chart")),
    upload$ui(ns("upload")),
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
  rhino_dat <- rhinos
  
  table$server("table", data = rhino_dat)
  chart$server("chart", data = rhino_dat)
  upload$server("upload", upload = upload)
  })
}


