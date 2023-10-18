# app/view/upload.R
box::use(
  shiny[tagList, h3, NS, fileInput, tableOutput, moduleServer, renderTable, textOutput, reactive, renderPlot, plotOutput, req],
  graphics[barplot],
  utils[read.table]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    #h3("Upload"), 
    fileInput(ns("up_file"), NULL, buttonLabel = "Upload...", multiple = TRUE),
    tableOutput(ns("up_table")),
    plotOutput(ns("up_plot"))
  )
}
  
#' @export
server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
   output$up_table <- renderTable(input$up_file)
   
  
   up_file_path <- reactive ({input$up_file$datapath})

   
   output$up_plot <- renderPlot({
	req (input$up_file$datapath)
   	dat <- read.table(up_file_path(), header=T, sep="\t")
	dat$SpYr <- paste(dat$Species, "_", dat$Year, sep="")
   	barplot(dat$Population, names.arg=dat$SpYr)
    })
  })
}


