# app/view/upload.R
box::use(
  shiny[tagList, h3, NS, fileInput, tableOutput, moduleServer, renderTable],
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    #h3("Upload"), 
    fileInput(ns("upload"), NULL, buttonLabel = "Upload...", multiple = TRUE),
    tableOutput(ns("up_table"))   
  )
}
  
#' @export
server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
   output$up_table <- renderTable(input$upload)
  })
}


