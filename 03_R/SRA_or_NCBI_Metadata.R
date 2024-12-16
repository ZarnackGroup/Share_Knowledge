# You can retrieve meta data from SRA or other NCBI data bases with the rentrez package
library(rentrez)

# with this you get all possible data bases
entrez_dbs()
entrez_db_summary("sra")

# These are the search specifications that you can use in [] as shown in the example below
entrez_db_searchable("sra")

# This is a search for experiments with the strategy RNA-seq, the organism Homosapiens for the year 2024
s <- entrez_search(db = "sra", term = "(RNA-seq [STRA]) AND (Homo Sapiens [ORGN] AND 2024 [PDAT])", retmax = 300)
entrez_db_links("sra")
# a draw back of this method is that you can retrieve only up to 300 entries 

# fetch the data
f <- entrez_fetch(db="sra", id = s$ids, retmode = "xml", rettype="runinfo", parsed=TRUE, use_history=TRUE)

# and make a usefull data frame out of it
meta_data <- lapply(f,function(x) XML::xmlToDataFrame(x)) %>% as.data.frame()
