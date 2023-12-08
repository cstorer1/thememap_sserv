#R
library ("tidyverse")

#get CompBio export data
theme_dat <- read.table("/var/www/html/temp/STORER_beech_laz_pos_tt_656d3f9297ac2.csv", header=F, stringsAsFactors=F)
theme_dat <- theme_dat[-1:-7,]
theme_dat <- as.data.frame(theme_dat)

#clean it up
#export <- theme_dat %>% 
#	filter( grepl("Entity", theme_dat)) %>%
#	mutate(across('theme_dat', str_replace, 'Entity=\\(e\\)', '')) %>%
#	mutate(across('theme_dat', str_replace, '\\(.*', ''))
export <- theme_dat %>%
        filter( grepl("Entity", theme_dat)) %>%
        mutate(across('theme_dat', \(x) str_replace(x, 'Entity=\\(e\\)', ''))) %>%
        mutate(across('theme_dat', \(x) str_replace(x, '\\(.*', '')))

#add gene_id to list so first row is kept in my_dat
theme_list <- append(export$theme_dat, c('group', 'gene_id'), after=0)
leng_list <- length(theme_list)
if(leng_list > 17){ theme_list <- theme_list[1:17] }

#now filter full user data
big_dat <- read.table("big_toy_data.txt", header=F, stringsAsFactors=F)
my_dat <- big_dat %>% filter(big_dat$V1 %in% theme_list)

