##############
# Libraries #
#############

library(tidyverse)
library(plyranges)
library(rtracklayer)

#####################
# Load BigWig files #
#####################

# This function loads the BigWig coverage as an RleList but subsets the coverage
#   to regions overlapping with the introns (+/-20 nt) that should be quantified
create_RleList <- function(bw_path, introns){
    return(import(bw_path, as="RleList", selection=(introns + 20)))
}


# The function takes introns stored in a GRanges object as well as the coverage
#   of a sample. The coverage object should be a list that has for the "+" and
#   "-" strand an RleList with the coverage.
calculate_ir_ratios_stranded <- function(introns, sample_coverage_stranded){
    
    # Add the original order as meta column
    introns$original_order <- seq_along(introns)
    
    # Itereate over the "+" and "-" strand
    introns <- lapply(c("+", "-"), function(current_strand){
        
        # Subset introns to current strand and fetch the first 20nt of the flanking exons
        introns_by_strand <- introns %>% plyranges::filter(strand == current_strand)
        exons_up <- flank(introns_by_strand, width=20)
        exons_down <- flank(introns_by_strand, width=20, start=FALSE)
        
        # Get the mean signal for the three regions
        introns_signal <- sample_coverage_stranded[[current_strand]][introns_by_strand] %>% mean
        exons_up_signal <- sample_coverage_stranded[[current_strand]][exons_up] %>% mean
        exons_down_signal <- sample_coverage_stranded[[current_strand]][exons_down] %>% mean
        
        # Calculate the IR ratios by dividing the intronic signal by the mean of the exonic signals
        ir_ratio <- introns_signal / cbind(exons_up_signal, exons_down_signal) %>% rowMeans
        
        # IR ratios greater than 1 are limited to 1
        ir_ratio[ir_ratio > 1] <- 1
        
        # Return a data.frame with the original order information and the quantifications
        return(data.frame(original_order = introns_by_strand$original_order,
                          ir_ratio = ir_ratio))
    }) %>% bind_rows(.)
    
    # Arrange by the original order and return a vector with the quantifications
    return(introns %>% dplyr::arrange(original_order) %>% pull(ir_ratio))
}

# The function takes introns stored in a GRanges object as well as the coverage
#   of a sample as an RleList
calculate_ir_ratios_unstranded <- function(introns, sample_coverage_unstranded){
    
    # Fetch the first 20nt of the flanking exons
    exons_up <- flank(introns, width=20)
    exons_down <- flank(introns, width=20, start=FALSE)
    
    # Get the mean signal for the three regions
    introns_signal <- sample_coverage_unstranded[introns] %>% mean
    exons_up_signal <- sample_coverage_unstranded[exons_up] %>% mean
    exons_down_signal <- sample_coverage_unstranded[exons_down] %>% mean
    
    # Calculate the IR ratios by dividing the intronic signal by the mean of the exonic signals
    exon_signal <- cbind(exons_up_signal, exons_down_signal) %>% rowMeans
    ir_ratio <- introns_signal / exon_signal
    
    # IR ratios greater than 1 are limited to 1
    ir_ratio[ir_ratio > 1] <- 1
    
    return(ir_ratio)
}


# Example

# Load introns and subset to first 100
introns <- readRDS("/Users/mariokeller/projects/IR_Normoxia_Hypoxia/Hernandez_et_al_2024/rds_files/se_introns_with_quantifications_including_APEXseq.rds") %>%
    slice(1:100)

# Create coverage RleLists. One for stranded coverage (we can discriminate signal from the + and - strand) and one for unstranded coverage
my_coverage_stranded <- list(
    "+" = create_RleList("/Users/mariokeller/projects/IR_Normoxia_Hypoxia/Hernandez_et_al_2024/data/BigWig_coverage/HUVEC/HUVEC_polyA_Hyp_Ctrl_1_forward.bw", introns),
    "-" = create_RleList("/Users/mariokeller/projects/IR_Normoxia_Hypoxia/Hernandez_et_al_2024/data/BigWig_coverage/HUVEC/HUVEC_polyA_Hyp_Ctrl_1_reverse.bw", introns)
)

my_coverage_unstranded <- create_RleList("/Users/mariokeller/projects/IR_Normoxia_Hypoxia/Hernandez_et_al_2024/data/BigWig_coverage/APEXseq/srsf7_pd_SRR14765727.bw", introns)

# Quantify IR ratios
calculate_ir_ratios_unstranded(introns, my_coverage_unstranded)
calculate_ir_ratios_stranded(introns, my_coverage_stranded)
