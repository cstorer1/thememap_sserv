#https://mastering-shiny.org/action-transfer.html
#https://shiny.posit.co/r/reference/shiny/1.7.0/fileinput
#https://www.r-bloggers.com/2022/12/redesigning-dashboards-with-shiny-and-rhino-world-banks-carbon-pricing/
box::use(
  shiny[moduleServer, NS, fluidRow, icon, h1, fileInput, tableOutput, renderTable,
	numericInput, reactive],
  semantic.dashboard[dashboardPage, dashboardHeader, dashboardBody, dashboardSidebar,
        sidebarMenu, menuItem],
)
#' @export
ui <- function(id) {
  ns <- NS(id)
  dashboardPage(
    dashboardHeader(center = h1("ThemeMap for CompBio")),
    dashboardSidebar(sidebarMenu(
      menuItem(tabName = "ind_gene", text = "Individual Gene Expression"),
      menuItem(tabName = "heatmap", text = "Heatmaps"),
      menuItem(tabName = "pca", text = "PCA"),
      menuItem(tabName = "venn", text = "Venn Plots")
    ), side = "top", visible = FALSE),
    dashboardBody(
      fluidRow(
      fileInput("upload", NULL, accept = c(".csv", ".txt"), buttonLabel = "Upload Dataset"),
      numericInput("n", "Rows", value = 5, min = 1, step = 1),
      tableOutput("head") 
      )
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
  data <- reactive({
    req(input$upload)
    
    ext <- tools::file_ext(input$upload$name)
    switch(ext,
      csv = vroom::vroom(input$upload$datapath, delim = ","),
      txt = vroom::vroom(input$upload$datapath, delim = "\t"),
      validate("Invalid file; Please upload a .csv or .txt file")
    )
  })
  
  output$head <- renderTable({
    head(data(), input$n)
  }) 
  })
}
