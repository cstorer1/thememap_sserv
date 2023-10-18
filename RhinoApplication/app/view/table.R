# app/view/table.R
box::use(
	 reactable, 
	 shiny[h3, moduleServer, NS, tagList], 
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    h3("Table"),
    reactable$reactableOutput(ns("table"))
  )
}

#' @export
server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
   output$table <- reactable$renderReactable(
     reactable$reactable(data)
     )
  })
}

