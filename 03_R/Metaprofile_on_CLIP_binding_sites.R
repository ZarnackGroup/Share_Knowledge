#############################
# metaprofile of clip crosslinks in window around BS
###########################

BS # = CLIP binding sites

# enlarge BS
half_window_size <- 10
window <- as.data.frame(BS+half_window_size )%>%
  arrange(desc(score)) %>%
  .[1:floor(NROW(BS)),] %>%
  makeGRangesFromDataFrame(keep.extra.columns = T)

# get crosslinks in rle format
cl_plus_rle <- import.bw("path/to/all_crosslinks.plus.bw", as = "Rle")
cl_minus_rle <- import.bw("path/to/all_crosslinks.minus.bw",  as = "Rle")

# make matix of crosslinks
cl_p <- as.matrix(cl_p_rle[window[strand(window) == "+"]])
cl_m <- as.matrix(cl_m_rle[window[strand(window) == "-"]])
cl <- rbind(cl_p, cl_m) 

# exclude windows with 0 crosslinks
cl_without_0 <- cl[rowSums(cl)!=0 ,] %>% 
   as.data.frame()%>%
   arrange(desc(rowSums(.))) %>%
   as.matrix()

# option: calculate z-scores



# make heatmap
col_fun <-  circlize::colorRamp2(c(0,10), c("white", "black"))
line <- HeatmapAnnotation(crosslinks = anno_lines(colSums(cl), height = unit(2, "cm"), ylim = c(0, 136000)))

ht_opt$heatmap_column_names_gp = gpar(fontsize = 5)


# label top genes
npc_cl_top_genes <- BS_15nt$gene_name
npc_cl_top_genes[duplicated(npc_cl_top_genes)] <- ""
npc_cl_top_genes[21:length(npc_cl_top_genes)] <- ""

Heatmap(npc_cl_without_0[1:1000,], col =col_fun, cluster_columns = F, cluster_rows = F, top_annotation = line, use_raster = T, raster_device = "png", raster_quality = 10, right_annotation = rowAnnotation(foo = anno_mark(at = 1:20, labels = npc_cl_top_genes)))
