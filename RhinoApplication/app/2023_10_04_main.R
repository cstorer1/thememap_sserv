box::use(
  shiny[moduleServer, NS, fluidRow, icon, h1, fileInput, tableOutput, renderTable],
    semantic.dashboard[
        dashboardPage,
        dashboardHeader, dashboardBody, dashboardSidebar,
        sidebarMenu, menuItem
    ]
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
       fileInput("upload", NULL, buttonLabel = "Upload...", multiple = TRUE),
       tableOutput("files")
      )
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
  output$files <- renderTable(input$upload)
  })
}
