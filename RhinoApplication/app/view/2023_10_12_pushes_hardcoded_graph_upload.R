# app/view/upload.R
box::use(
  shiny[tagList, h3, NS, fileInput, tableOutput, moduleServer, renderTable, textOutput, reactive, renderPlot, plotOutput],
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
   
   #output$up_file_path <- reactive ({input$up_file$datapath})
   output$up_plot <- renderPlot({
   	dat <- read.table("/huge1/cstorer/ThemeMap/thememap_sserv/RhinoApplication/app/my_dragons.txt", header=T, sep="\t")
   	dat$SpYr <- paste(dat$Species, "_", dat$Year, sep="")
   	barplot(dat$Population, names.arg=dat$SpYr)
    })
  })
}


