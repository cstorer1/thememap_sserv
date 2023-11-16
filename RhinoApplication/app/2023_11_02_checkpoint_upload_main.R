# app/main.R
#renv::install(c("dplyr", "echarts4r", "htmlwidgets", "reactable", "tidyr"))
#renv::snapshot()

# app/main.R
box::use(
  #shiny [NS, moduleServer, fluidRow, icon, h1], 
  shiny[...],
  semantic.dashboard [dashboardPage, dashboardHeader, 
  dashboardSidebar, sidebarMenu, menuItem, dashboardBody]
)

box::use(
  app/view/hmap,
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  dashboardPage(
    dashboardHeader(center = h1("ThemeMap for CompBio") ),
    dashboardSidebar(sidebarMenu(
      menuItem(tabName = "ind_gene", text = "Individual Gene Expression"),
      menuItem(tabName = "ind_gene", text = "Heatmap"),
      menuItem(tabName = "pca", text = "PCA"),
      menuItem(tabName = "venn", text = "Venn Plots")
    ), side = "top", visible = FALSE),
    dashboardBody(
      fluidRow(
        fileInput(ns("dataFile"), NULL, buttonLabel = "Upload...", multiple = TRUE),
	tableOutput(ns("fileTable")),
	hmap$hmapUI(ns("hmap"))
      )
    )
   )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$fileTable <- renderTable(input$dataFile)
    		       
    common <- reactiveValues( my_path = "" )
    observeEvent(input$dataFile, { common$my_path <- input$dataFile$datapath })

    hmap$hmapServer("hmap", common)
  })
}


