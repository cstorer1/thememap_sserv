# app/view/bar.R
box::use(
	 shiny[...],
	 graphics[barplot]
)
box::use(
  app/view/upload,
)


#' @export
barUI <- function(id) {
  ns <- NS(id)

  tagList(
    tableOutput(ns("up_table")),
    plotOutput(ns("up_plot"))
    )
}

#' @export
barServer <- function(id, data) {
	moduleServer(id, function(input, output, session) {
	
	up_file_path <- reactive ({input$up_file$datapath})
   	
	output$up_plot <- renderPlot({
   	  req (input$up_file$datapath)
   	  dat <- read.table(up_file_path(), header=T, sep="\t")
	  dat$SpYr <- paste(dat$Species, "_", dat$Year, sep="")
	  barplot(dat$Population, names.arg=dat$SpYr)
    	})
	})
}
