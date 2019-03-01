#!/bin/bash

FINAL="FINAL"
mkdir $FINAL
#for mass in `seq 105 0.1 150`;
for mass in `seq 150 0.1 160`;
do
    MASS0=$mass
    DELTA=0.1
    MASS1=$(echo "$MASS0+$DELTA" | bc -l)
    RUNDIR="CONDOR_${MASS0}to${MASS1}"
    [ -d $RUNDIR ] || continue
    echo "Finalizing job $job: $MASS0 - $MASS1"
    ./finish.sh $RUNDIR NNLO.txt
    EXITSTATUS=$?
    [ "$EXITSTATUS" == "0" ] || continue
    cp -v $RUNDIR/NNLO.pdf.txt $FINAL/NNLO_${MASS0}to${MASS1}.pdf.txt
    [ "$EXITSTATUS" == "0" ] || continue
    cp -v $RUNDIR/NNLO.txt $FINAL/NNLO_${MASS0}to${MASS1}.txt
    [ "$EXITSTATUS" == "0" ] || continue
    #cp -v $RUNDIR/histograms.txt $FINAL/histograms_${MASS0}to${MASS1}.txt
    rm -r $RUNDIR
done


