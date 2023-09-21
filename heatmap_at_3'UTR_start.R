

#############################
# heatmap UTR starts
###########################
# annotated UTRs
UTRs <-annotation[annotation$type=="UTR"]

#
hit_UTRs # UTRs with any signal

# get range of whole UTR that was hit w
hit_3UTRs <- subsetByOverlaps(UTRs, high_3UTRs)
hit_3UTRs_nondupl <- hit_3UTRs[duplicated(hit_3UTRs$gene_id)==F]

UTR3_window_plus <- GRanges(seqnames = seqnames(hit_3UTRs_nondupl[strand(hit_3UTRs_nondupl)=="+"]),
                            strand=strand(hit_3UTRs_nondupl[strand(hit_3UTRs_nondupl)=="+"]),
                            ranges =IRanges(
                              start=start(hit_3UTRs_nondupl[strand(hit_3UTRs_nondupl)=="+"])-200,
                              end = start(hit_3UTRs_nondupl[strand(hit_3UTRs_nondupl)=="+"])+300))

UTR3_window_minus<- GRanges(seqnames = seqnames(hit_3UTRs_nondupl[strand(hit_3UTRs_nondupl)=="-"]),
                            strand=strand(hit_3UTRs_nondupl[strand(hit_3UTRs_nondupl)=="-"]),
                            ranges = IRanges(
                              start = end(hit_3UTRs_nondupl[strand(hit_3UTRs_nondupl)=="-"])-300, 
                              end= end(hit_3UTRs_nondupl[strand(hit_3UTRs_nondupl)=="-"])+200)) 

# get plus and minus crosslinks from an rle of the raw bigwig
cl_plus_3UTRs<- as.matrix(bw_plus_rle[UTR3_window_plus]) 


cl_minus_3UTRs<- as.matrix(bw_minus_rle[UTR3_window_minus]) %>% .[,ncol(.):1]

# combine 
cl_3UTR <- rbind(cl_plus_3UTRs, cl_minus_3UTRs) 

# z-norm per row
cl_3UTR_means <- apply(cl_3UTR, MARGIN=1, mean)
cl_3UTR_sd <- apply(cl_3UTR,1,sd)
cl_3UTR_z <- (cl_3UTR - cl_3UTR_means)/cl_3UTR_sd
cl_3UTR_z_clean <- cl_3UTR_z[rowSums(cl_3UTR_z==0)!=ncol(cl_3UTR_z),] #throw out only zero
cl_3UTR_z_clean[is.na(cl_3UTR_z_clean)] <- 0

# order
cl_3UTR_z_clean <- cl_3UTR_z_clean[order(max.col(cl_3UTR_z_clean, "first")),] %>%
  .[max.col(., "first")>200,]

# change row and colnames
colnames(cl_3UTR_z_clean) <- c(-200, rep("",99), -100, rep("", 99),0,
                               rep("", 99), 100, rep("", 99), 200, rep("", 99), 300 )

#change color of heatmap
col_fun= circlize::colorRamp2(c(4,2, 0, -2,-4), c(report_color[3],
                                                  report_color[5], report_color[8],
                                                  report_color[11], report_color[13]))

# plot barplot of colSums an top of heatmap 
# bar <- HeatmapAnnotation(crosslinks = anno_barplot(colSums(cl_3UTR >= 3), height = unit(2, "cm")))
# bar_m <- HeatmapAnnotation(crosslinks = anno_barplot(colSums(cl_minus_3UTRs != 0), height = unit(2, "cm")))

line <- HeatmapAnnotation(crosslinks = anno_lines(colSums(cl_3UTR), height = unit(4, "cm")))

# make Heatmap
region_hmap <- Heatmap(cl_3UTR_z_clean, cluster_columns = F, cluster_rows = F, top_annotation = line,  show_row_dend = F, name = paste("#", nrow(cl_3UTR_z_clean)))
#col=col_fun,

region_hmap
