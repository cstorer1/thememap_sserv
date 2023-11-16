# app/view/upload.R
box::use(
  shiny[tagList, h3, NS, fileInput, tableOutput, moduleServer, renderTable, 
	textOutput, reactive, renderPlot, plotOutput, req],
  #ComplexHeatmap[draw, anno_simple, anno_block, columnAnnotation, rowAnnotation, Heatmap],
  #grid[gpar, unit],
  #circlize[colorRamp2],

  utils[read.table]
)



#' @export
uploadUI <- function(id) {
  ns <- NS(id)

  tagList(
    #h3("Upload"), 
    fileInput(ns("up_file"), NULL, buttonLabel = "Upload...", multiple = TRUE),
    tableOutput(ns("up_table")),
    #plotOutput(ns("up_plot"))
  )
}
  
#' @export
uploadServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
   output$up_table <- renderTable(input$up_file)
   
  
  up_file_path <- reactive ({input$up_file$datapath})
  	
   
  })
}
