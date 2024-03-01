QUANTDIR="/home/mariokeller/IR_Normoxia_Hypoxia/IRFinder_analysis/ir_quantifications"
DIFFDIR="/home/mariokeller/IR_Normoxia_Hypoxia/IRFinder_analysis/ir_diff"
mkdir $DIFFDIR

GROUP1="HUVEC_polyA_Hyp_Heat"
GROUP2="HUVEC_polyA_Hyp_Ctrl"

OUTDIR="${DIFFDIR}/${GROUP1}_vs_${GROUP2}"
mkdir $OUTDIR
singularity run /home/mariokeller/applications/IRFinder Diff \
-g:HypHeat $QUANTDIR/$GROUP1/*/IRFinder-IR-dir.txt \
-g:HypCtrl $QUANTDIR/$GROUP2/*/IRFinder-IR-dir.txt \
-m deseq \
-o $OUTDIR




GROUP1="HUVEC_polyA_Nor_Heat"
GROUP2="HUVEC_polyA_Nor_Ctrl"

OUTDIR="${DIFFDIR}/${GROUP1}_vs_${GROUP2}"
mkdir $OUTDIR
singularity run /home/mariokeller/applications/IRFinder Diff \
-g:NorHeat $QUANTDIR/$GROUP1/*/IRFinder-IR-dir.txt \
-g:NorCtrl $QUANTDIR/$GROUP2/*/IRFinder-IR-dir.txt \
-m deseq \
-o $OUTDIR




GROUP1="HUVEC_polyA_Hyp_Ctrl"
GROUP2="HUVEC_polyA_Nor_Ctrl"

OUTDIR="${DIFFDIR}/${GROUP1}_vs_${GROUP2}"
mkdir $OUTDIR
singularity run /home/mariokeller/applications/IRFinder Diff \
-g:HypCtrl $QUANTDIR/$GROUP1/*/IRFinder-IR-dir.txt \
-g:NorCtrl $QUANTDIR/$GROUP2/*/IRFinder-IR-dir.txt \
-m deseq \
-o $OUTDIR




GROUP1="HUVEC_polyA_Hyp_Heat"
GROUP2="HUVEC_polyA_Nor_Heat"

OUTDIR="${DIFFDIR}/${GROUP1}_vs_${GROUP2}"
mkdir $OUTDIR
singularity run /home/mariokeller/applications/IRFinder Diff \
-g:HypHeat $QUANTDIR/$GROUP1/*/IRFinder-IR-dir.txt \
-g:NorHeat $QUANTDIR/$GROUP2/*/IRFinder-IR-dir.txt \
-m deseq \
-o $OUTDIR
