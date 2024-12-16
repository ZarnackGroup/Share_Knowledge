# This is how you can access the Metadata from Encode in R. 
# ---------------------------------------------------------
# In my case I wanted to know the distributions of read counts in all (shRNA) RNAseq experiments from Encode.

library(httr)
library(jsonlite)
library(tidyverse)

# where to look
base_url <- "https://www.encodeproject.org/"

# search terms
## see https://www.encodeproject.org/help/rest-api/ for more info
query <- "search/?type=File&file_format=fastq&assay_title=shRNA%20RNA-seq&frame=object&limit=all" 
## %20 encodes an empthy space

# Make API request
response <- GET(paste0(base_url, query), add_headers(accept = "application/json"))

# Parse JSON response
data <- fromJSON(content(response, "text", encoding = "UTF-8"))

# Most metadata is stored in data$`@graph`
data$`@graph`$read_count

all_encode_shRNAseq_fastqs <- data$`@graph` %>% subset(status == "released")


# plot read counts
ggplot(all_encode_shRNAseq_fastqs, aes(x = read_count)) +
  geom_histogram()


# getting the additional organism info
# --> the organism info you get from a search with type Experiment instead of type File

query <- "search/?type=Experiment&assay_title=shRNA%20RNA-seq&limit=all"
response <- GET(paste0(base_url, query), add_headers(accept = "application/json"))
exp_data <- fromJSON(content(response, "text", encoding = "UTF-8"))


exp_data_small <- exp_data$`@graph` %>% select(c("accession", "biosample_summary")) %>%
  rowwise() %>%
  mutate(organism  = paste(unlist(strsplit(biosample_summary, split = " "))[[1]], unlist(strsplit(biosample_summary, split = " "))[[2]])) 




