mkdir /home/mariokeller/IR_Normoxia_Hypoxia/IRFinder_analysis/REF/

# Annotation
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/gencode.v38.annotation.gtf.gz \
-O /home/mariokeller/IR_Normoxia_Hypoxia/IRFinder_analysis/REF/transcripts.gtf.gz

gunzip /home/mariokeller/IR_Normoxia_Hypoxia/IRFinder_analysis/REF/transcripts.gtf.gz

# Reference gneome
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/GRCh38.primary_assembly.genome.fa.gz \
-O /home/mariokeller/IR_Normoxia_Hypoxia/IRFinder_analysis/REF/genome.fa.gz

gunzip /home/mariokeller/IR_Normoxia_Hypoxia/IRFinder_analysis/REF/genome.fa.gz

