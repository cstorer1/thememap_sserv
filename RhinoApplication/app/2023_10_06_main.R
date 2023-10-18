#https://mastering-shiny.org/action-transfer.html
#https://shiny.posit.co/r/reference/shiny/1.7.0/fileinput
#https://www.r-bloggers.com/2022/12/redesigning-dashboards-with-shiny-and-rhino-world-banks-carbon-pricing/
box::use( shiny[...], semantic.dashboard[...] )

#' @export
ui <-  function(id) {
  ns <- NS(id)
  dashboardPage(
    dashboardHeader(center = h1("ThemeMap for CompBio")),
    dashboardSidebar(sidebarMenu(
      menuItem(tabName = "ind_gene", text = "Heatmap")
    ), side = "top", visible = FALSE),
     dashboardBody(
       fluidRow(
         fileInput(ns("upload"), NULL, buttonLabel = "Upload...", multiple = TRUE),
         tableOutput(ns("files")) 
         )
     )
   )  
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
      output$files <- renderTable(input$upload) 
      }
  )
}


