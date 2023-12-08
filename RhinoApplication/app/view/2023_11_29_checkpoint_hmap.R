# app/view/hmap.R
box::use(
  #shiny[tagList, h3, NS, fileInput, tableOutput, moduleServer, renderTable,
  #      textOutput, reactive, renderPlot, plotOutput, req, renderText],
  shiny[...],
  ComplexHeatmap[draw, anno_simple, anno_block, columnAnnotation, rowAnnotation, Heatmap],
  grid[gpar, unit],
  circlize[colorRamp2],

  utils[read.table],
  app/view/upload,
  
)


#' @export
hmapUI <- function(id) {
	ns <- NS(id)
	tagList(
	   plotOutput(ns("up_plot")),
	   
	)
}

#' @export
hmapServer <- function(id, common) {
 moduleServer(id, function(input, output, session) { 
  #get values from common		      
  up_file_path <- reactive({ common$my_path }) #<-------- location of uploaded file
  my_col_fun <- reactive({ common$my_col })    #<-------- color option	
	
  output$up_plot <- renderPlot({
	req( up_file_path() )
	dat <- read.table( up_file_path(), header=T, sep="\t")
	attach(dat)
        ncol <- ncol(dat)
        mat <- as.matrix(dat[c(3:ncol)])
        tmat <- t(mat)
        colnames(tmat) <- dat$gene_id
        groups <- dat$group

        #color function for scaled expression:
        col_fun1 = colorRamp2(c(1, 100), c("black", "red"))  		#aka bloodmoon
        col_fun1(seq(0, 3))
	col_fun2 = colorRamp2(c(1, 100), c("black", "yellow"))		#aka yellowjacket
        col_fun2(seq(0, 3))
	col_fun3 = colorRamp2(c(1, 100), c( "ivory2",  "red3"))  	#aka poppies
	col_fun3(seq(0, 3))
	col_fun4 = colorRamp2(c(1, 50, 100), c("purple", "green2", "yellow"))          #aka mardis gras
        col_fun4(seq(0, 3))

        col_ha = columnAnnotation(
                column_group = anno_block(gp = gpar(fill = c("black", "darkgreen", "darkblue", "orange", "gold")),
                labels = unique(dat$group),
		

		labels_gp = gpar(col = "white", fontsize = 28)
                ),
                simple_anno_size = unit(4, "cm")
        )	
	#get function name from my_col_fun
        my_col <- get( my_col_fun() )     #<----Use get func to search for object by name

	ht = Heatmap(tmat, name = "Delta Delta Values", 
		col <- my_col ,           #<-----Now assign "my_col" to the col attribute
                cluster_rows = FALSE,
                cluster_columns = TRUE,
                column_title = "CompBio Heatmap",
                column_names_side = "top",
                column_title_side = "top",
                show_column_names = F,
                width = unit(20, "cm"),
                height = unit(4, "cm"),
                column_split = factor(dat$group, levels = unique(dat$group) ),
                cluster_row_slices = FALSE,
                cluster_column_slices = FALSE,
                row_title_rot = 0,
                row_names_gp = gpar(fontsize = 16),
                top_annotation = col_ha,
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


