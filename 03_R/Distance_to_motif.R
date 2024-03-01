
library(BSgenome.Mmusculus.UCSC.mm10)
library(Biostrings)


interesting_sequence <- peaks_granges + 300
interesting_sequence <- getSeq(interesting_seqeunce , x = Mmusculus)

drach <- vmatchPattern(pattern= DRACH, x = interesting_sequence)

distance <- distanceToNearest(peaks_granges, drach)