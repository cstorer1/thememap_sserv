#https://mastering-shiny.org/action-transfer.html
#https://shiny.posit.co/r/reference/shiny/1.7.0/fileinput
#https://www.r-bloggers.com/2022/12/redesigning-dashboards-with-shiny-and-rhino-world-banks-carbon-pricing/

#launch command (run in /RhinoApplication):
# R -e 'shiny::runApp(launch.browser = FALSE, port = 3840, host = getOption("shiny.host", "0.0.0.0"))'

box::use( shiny[...], semantic.dashboard[...] )
box::use(
  app/view/upload,
)


#' @export
ui <-  function(id) {
  ns <- NS(id)
  dashboardPage(
    dashboardHeader(center = h1("ThemeMap for CompBio")),
    dashboardSidebar(sidebarMenu(
      menuItem(tabName = "ind_gene", text = "Individual Gene Expression"),			 
      menuItem(tabName = "ind_gene", text = "Heatmap"),
      menuItem(tabName = "pca", text = "PCA"),
      menuItem(tabName = "venn", text = "Venn Plots")
    ), side = "top", visible = FALSE),
    dashboardBody(
      fluidRow(
        upload$ui(ns("upload")),
	files$ui(ns("files"))
      )
      )
    )  
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
      output$files <- renderTable(input$upload) 
      upload$server("upload", upload = upload)
      files$server("files", files = files)  
    }
  )
}


