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
	#dat <- read.table( up_file_path(), header=T, sep="\t")
	dat <- read.table( up_file_path(), header=FALSE, sep="\t") #long/skinny don't read header
	ncol <- ncol(dat)

	#get groups
	groups <- as.character(dat[1,-1])
	dat <- dat[-1,]

	#do row and column stuff
	colnames(dat) <- dat[1,]
	dat <- dat[-1,]
	rownames <- dat$gene_id
	dat$gene_id <- NULL

	#change dat to numeric matrix
	dat <- sapply(dat, as.numeric)
	dat <- as.matrix(dat)
	#add row names
	rownames(dat) <- rownames


	tmat <- dat #<-------------hack to fit old code for now

		
	#attach(dat)
        #ncol <- ncol(dat)
        #mat <- as.matrix(dat[c(3:ncol)])
        #tmat <- t(mat)		#<---------------------for short fat data
        
	#colnames(tmat) <- dat$gene_id
        #groups <- dat$group

	#get data range:
	tmat_max <- max(tmat)
	tmat_min <- min(tmat)
	tmat_range <- tmat_max - tmat_min
	tmat_50 <- 0.50 * tmat_range
	tmat_25 <- 0.25 * tmat_range

        #color function for scaled expression:
        col_fun1 = colorRamp2(c(tmat_min, tmat_max), c("black", "red"))  		#aka bloodmoon
        col_fun2 = colorRamp2(c(tmat_min, tmat_max), c("black", "yellow"))		#aka yellowjacket
        col_fun3 = colorRamp2(c(tmat_min, tmat_max), c( "ivory2",  "red3"))  	#aka poppies
	col_fun4 = colorRamp2(c(tmat_min, tmat_50, tmat_max), c("purple", "green2", "yellow"))          #aka mardis gras
        col_fun5 = colorRamp2(c(tmat_min, tmat_max), c("red", "black"))                 #aka inverse_bloodmoon

        col_ha = columnAnnotation(
                column_group = anno_block(gp = gpar(fill = c("black", "darkgreen", "darkblue", "orange", "gold")),
                labels = unique(groups),
		

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
                #height = unit(4, "cm"),
		height = unit(0.65*nrow(dat), "cm"),
                column_split = factor(groups, levels = unique(groups) ),
                cluster_row_slices = FALSE,
                cluster_column_slices = FALSE,
                row_title_rot = 0,
                row_names_gp = gpar(fontsize = 16),
                top_annotation = col_ha,
                heatmap_legend_param = list(
                        title="Expression",
                        legend_direction = "horizontal",
			at = c(tmat_min, tmat_25, tmat_50, tmat_max)
                ),
         show_heatmap_legend = TRUE
        )
	draw(ht, heatmap_legend_side = "bottom", annotation_legend_side="left")
    })
  })
}


