#SRT_LHAPDF_DATA_PATH_SCRAMRTDEL=/cvmfs/cms.cern.ch/slc6_amd64_gcc630/external/lhapdf/6.2.1-gnimlf2/share/LHAPDF LHAPDF_DATA_PATH=/cvmfs/cms.cern.ch/slc6_amd64_gcc630/external/lhapdf/6.2.1-gnimlf2/share/LHAPDF ./local_run.sh z 105to160 input_z_m50_NNPDF31_nnlo_luxqed.txt histograms.txt root . 4

for RF in R1F2 R1F5 R2F1 R2F2 R5F1 R5F5 
do
    SRT_LHAPDF_DATA_PATH_SCRAMRTDEL=/cvmfs/cms.cern.ch/slc6_amd64_gcc630/external/lhapdf/6.2.1-gnimlf2/share/LHAPDF LHAPDF_DATA_PATH=/cvmfs/cms.cern.ch/slc6_amd64_gcc630/external/lhapdf/6.2.1-gnimlf2/share/LHAPDF ./local_run.sh z 105to160_$RF input_z_m50_NNPDF31_nnlo_luxqed_${RF}.txt histograms.txt root . 8
done
