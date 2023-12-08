# app/main.R
#renv::install(c("dplyr", "echarts4r", "htmlwidgets", "reactable", "tidyr"))
#renv::snapshot()

# app/main.R
box::use(
  #shiny [NS, moduleServer, fluidRow, icon, h1], 
  shiny[...],
  semantic.dashboard [dashboardPage, dashboardHeader, 
  dashboardSidebar, sidebarMenu, menuItem, dashboardBody],
  DT[...]
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
	titlePanel(title=div(img(src = "static/images/toy_data.png", width="300px", height="150px"), h3("Example Data Format", align="center"))),
        fileInput(ns("dataFile"), NULL, buttonLabel = "Upload:", multiple = FALSE),	
	
	selectInput(ns("col_fun"), label = "",
        choices = list("BloodMoon" = "col_fun1", 
		       "Yellowjacket" = "col_fun2", 
		       "Poppies" = "col_fun3", 
		       "Mardis Gras" = "col_fun4"), 
        selected = "col_fun1"),
	
	hmap$hmapUI(ns("hmap"))
      ),
    )
   ) 
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$fileTable <- renderTable(input$dataFile)
    
    common <- reactiveValues( my_path = "" )
    observeEvent(input$dataFile, { common$my_path <- input$dataFile$datapath })
    
    common <- reactiveValues ( my_col = "" )
    observeEvent(input$col_fun, { common$my_col <- input$col_fun })    
   
    hmap$hmapServer("hmap", common)
  })
}


