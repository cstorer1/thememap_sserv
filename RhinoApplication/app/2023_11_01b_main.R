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
  app/view/upload, 
  #app/view/bar,
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
        upload$uploadUI(ns("upload"))

	
      )
    )
   )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    common <- reactiveValues(
	dataFile = ""
    )
    observeEvent(input$svc, {common$dataFile <- input$svc})
    upload$uploadServer("upload", common)     #<---- like " mod1_server("mod1", common) "
    #bar$barServer("bar", common)
  })
}


