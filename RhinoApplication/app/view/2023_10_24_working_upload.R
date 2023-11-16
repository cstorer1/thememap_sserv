# app/view/upload.R
box::use(
  shiny[tagList, h3, NS, fileInput, tableOutput, moduleServer, renderTable, 
	textOutput, reactive, renderPlot, plotOutput, req],
  ComplexHeatmap[draw, anno_simple, anno_block, columnAnnotation, rowAnnotation, Heatmap],
  grid[gpar, unit],
  circlize[colorRamp2],

  utils[read.table]
)



#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
 
    #textOutput(ns("test_path")),  #<------------------DEBUG

    fileInput(ns("up_file"), NULL, buttonLabel = "Upload...", multiple = TRUE),
    tableOutput(ns("up_table")),
    plotOutput(ns("up_plot"))
  )
}
  
#' @export
server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
   output$up_table <- renderTable(input$up_file)
   
  
   up_file_path <- reactive ({input$up_file$datapath})
  
   #output$test_path <- up_file_path  #<------------------DEBUG
   
   output$up_plot <- renderPlot({
	req (input$up_file$datapath)
   	dat <- read.table(up_file_path(), header=T, sep="\t")
	#dat$SpYr <- paste(dat$Species, "_", dat$Year, sep="")
   	#barplot(dat$Population, names.arg=dat$SpYr)
	attach(dat)
	ncol <- ncol(dat)
	mat <- as.matrix(dat[c(3:ncol)])
	tmat <- t(mat)
	colnames(tmat) <- dat$gene_id
	groups <- dat$group
	row_cats <- c("sig", "not_sig", "not_sig")

	#color function for scaled expression:
	expr_col_fun = colorRamp2(c(1, 100), c("black", "red"))
	expr_col_fun(seq(0, 3))

	col_ha = columnAnnotation(
        	column_group = anno_block(gp = gpar(fill = c("darkgreen", "blue")),
        	labels = c("Naive_Pool", "Treated"),
        	labels_gp = gpar(col = "white", fontsize = 28)
        	),
        	simple_anno_size = unit(4, "cm")
	)

	row_ha = rowAnnotation(
        	row_group = anno_block( gp = gpar(fill = c("grey", "grey50")),
        	labels = c("Sig", "NON-SIG"),
        	labels_gp = gpar(col = "black", fontsize = 10),
        	),
        	simple_anno_size = unit(4, "cm")
	)

	ht = Heatmap(tmat, name = "Delta Delta Values", col = expr_col_fun,
         	cluster_rows = FALSE,
         	cluster_columns = TRUE,
         	column_title = "BLOOD: Baseline Expression",
         	column_names_side = "top",
         	column_title_side = "top",
         	show_column_names = F,
         	width = unit(20, "cm"),
         	height = unit(4, "cm"),
         	column_split = factor(dat$group, levels = unique(dat$group) ),
         	row_split = factor(row_cats, levels = unique(row_cats) ),
         	cluster_row_slices = FALSE,
         	cluster_column_slices = FALSE,
         	row_title_rot = 0,
         	row_names_gp = gpar(fontsize = 16),
         	top_annotation = col_ha,
         	left_annotation = row_ha,
         	heatmap_legend_param = list(
         	        title="Scaled Expression",
                	 at = c(1,25,50,100)
         	),
         show_heatmap_legend = TRUE
 	)

 	draw(ht, heatmap_legend_side = "bottom", annotation_legend_side="left")
    })
  })
}




