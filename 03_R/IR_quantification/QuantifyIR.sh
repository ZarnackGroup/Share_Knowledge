# Create folders for experimental groups

BAMDIR="/home/mariokeller/IR_Normoxia_Hypoxia/bam"
QUANTDIR="/home/mariokeller/IR_Normoxia_Hypoxia/IRFinder_analysis/ir_quantifications"
mkdir $QUANTDIR

for GROUP in HUVEC_polyA_Nor_Ctrl HUVEC_polyA_Nor_Heat HUVEC_polyA_Hyp_Ctrl HUVEC_polyA_Hyp_Heat
do
	GROUPDIR="${QUANTDIR}/${GROUP}"
	mkdir $GROUPDIR
	for REP in 1 2 3
	do
		REPDIR="${GROUPDIR}/${GROUP}_${REP}"
		mkdir $REPDIR
		singularity run /home/mariokeller/applications/IRFinder BAM \
		-r /home/mariokeller/IR_Normoxia_Hypoxia/IRFinder_analysis/REF \
		-d $REPDIR \
		${BAMDIR}/${GROUP}_${REP}.bam
	done
done
