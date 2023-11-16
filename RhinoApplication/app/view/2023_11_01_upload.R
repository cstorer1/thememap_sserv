# app/view/upload.R
box::use(
  shiny[tagList, h3, NS, fileInput, tableOutput, moduleServer, renderTable, textOutput, reactive, renderPlot, plotOutput, req],
  #graphics[barplot],
  utils[read.table]
)

#' @export
uploadUI <- function(id) {
  ns <- NS(id)

  tagList(
    fileInput(ns("up_file"), NULL, buttonLabel = "Upload...", multiple = TRUE),
    tableOutput(ns("up_table")),
    #plotOutput(ns("up_plot"))
    textOutput(ns("my_file"))
  )
}
  
#' @export
uploadServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
   output$up_table <- renderTable(input$up_file)
     
   output$my_file <- reactive ({input$up_file$datapath})
   
  })
}


