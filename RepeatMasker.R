library(AnnotationHub)
ah = AnnotationHub()

query(ah, c("RepeatMasker", "Mus musculus"))


repeat_masker <- ah[["AH99012"]]


repeat_masker[repeat_masker$repName == "MMSAT4"]
