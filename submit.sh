#!/bin/bash
[ "$WORKDIR" == "" ] && export WORKDIR="/tmp/amarini/"

#MASS0=$(($1+105))
MASS0=$1
MASS1=$(($MASS0+1))

BASEDIR=/afs/cern.ch/user/a/amarini/work/FEWZ/FEWZ_3.1.rc/bin
echo "Executing job ${1}. Mass range is $MASS0 - $MASS1"

## SCRAM 
cd /afs/cern.ch/user/a/amarini/work/ChHiggs2017/CMSSW_9_4_1/src
eval `scramv1 runtime -sh`

## MOVE TO BASEDIR
cd $BASEDIR
## for some reasons I can't use absolute paths, or paths in general
#mkdir -p $BASEDIR
WORKDIR=./

INPUT=CONDOR_input_z_m50_NNPDF31_nnlo_luxqed_${MASS0}to${MASS1}.txt
HISTO=CONDOR_histograms_${MASS0}to${MASS1}.txt
cp -v $BASEDIR/input_z_m50_NNPDF31_nnlo_luxqed_XXX_YYY.txt $WORKDIR/$INPUT
cp -v $BASEDIR/histograms_XXX_YYY.txt $WORKDIR/$HISTO
sed -i'' "s/XXX/${MASS0}/g" $WORKDIR/$INPUT
sed -i'' "s/YYY/${MASS1}/g" $WORKDIR/$INPUT

sed -i'' "s/XXX/${MASS0}/g" $WORKDIR/$HISTO
sed -i'' "s/YYY/${MASS1}/g" $WORKDIR/$HISTO

## I don't know why it search it there
#WORKDIR=jobs
echo "INPUT File: ${WORKDIR}/$INPUT"
echo "HISTO File: ${WORKDIR}/$HISTO"
echo "RUNDIR:CONDOR_${MASS0}to${MASS1}"
SRT_LHAPDF_DATA_PATH_SCRAMRTDEL=/cvmfs/cms.cern.ch/slc6_amd64_gcc630/external/lhapdf/6.2.1-gnimlf2/share/LHAPDF LHAPDF_DATA_PATH=/cvmfs/cms.cern.ch/slc6_amd64_gcc630/external/lhapdf/6.2.1-gnimlf2/share/LHAPDF ./local_run.sh z $WORKDIR/CONDOR_${MASS0}to${MASS1} ${WORKDIR}/$INPUT ${WORKDIR}/$HISTO txt . 4

### RSYNC WORKDIR (so afs don't die)
#rsync -avP $WORKDIR/${MASS0}to${MASS1} $BASEDIR/jobs/
touch logs/${MASS0}to${MASS1}.done
