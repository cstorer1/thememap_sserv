
#launch the shiny server
#screen -S launch_thememap_sserv
#cd /huge1/cstorer/ThemeMap/thememap_sserv/RhinoApplication
#R -e 'shiny::runApp(launch.browser = FALSE, port = 3840, host = getOption("shiny.host", "0.0.0.0"))'
#ctrl-A ctrl-D to detatch

#or:
#R
#library(rhino)
#library(semantic.dashboard)
#shiny::runApp(launch.browser = FALSE, port = 3840, host = getOption("shiny.host", "0.0.0.0"))
#ctrl-A ctrl-D to detatch

box::use(
    shiny[moduleServer, NS, fluidRow, icon, h1],
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
  dashboardHeader(left = h1("ThemeMap for CompBio")),
    dashboardSidebar(sidebarMenu(
      menuItem(tabName = "ind_gene", text = "Individual Gene Expression"),
      menuItem(tabName = "heatmap", text = "Heatmaps"),
      menuItem(tabName = "pca", text = "PCA"),
      menuItem(tabName = "venn", text = "Venn Plots")
    ), side = "top", visible = FALSE),
    dashboardBody(
      fluidRow(
      )
    )
  )
}
#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
  })
}

