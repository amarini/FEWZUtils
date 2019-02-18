import os,sys

from optparse import OptionParser

usage='''
   %prog  file pdf scale_files
'''
parser=OptionParser(usage=usage)
#parser.add_option("-p","--pdf",action='store_true',help="loop over pdfs files",default=False)
opts,args=parser.parse_args()

import ROOT

def getSigmaAndError(fname):
    fin=open(fname,"r")
    isResult=False
    sigma=None
    error=None
    for line in fin:
        if not isResult and 'RESULT' in line: 
            isResult=True
            continue
        if isResult and 'Sigma' in line:
            sigma=float(line.split('=')[1].split()[0])
        if isResult and 'Error' in line:
            error=float(line.split('=')[1].split()[0])
        if isResult and '====' in line: break
    fin.close()
    return sigma,error

sigma,error=getSigmaAndError(args[0])

pdfs=[]
fin=open(args[1],"r")
isResult=False

for line in fin:
    if not isResult and 'RESULT' in line: 
        isResult=True
        continue
    if isResult and 'Sigma' in line:
        sigma=float(line.split('=')[1].split()[0])
        pdfs.append(sigma)
    if isResult and '====' in line: break

pdfs.sort()

print "---------------------"
pdfrange=(pdfs[-1]-pdfs[0])/2.
print "pdfs val extreme=",pdfs[0],pdfs[-1],"Error=",pdfrange
alpha=1.-ROOT.RooStats.SignificanceToPValue(1)*2
#alpha=1.-ROOT.RooStats.SignificanceToPValue(2)*2
lo= int((0.5-alpha/2.)*len(pdfs))
hi= int((0.5+alpha/2.)*len(pdfs))
pdflo = pdfs[lo]
pdfhi = pdfs[hi]
pdf68 = (pdfhi-pdflo)/2.
print "pdfs val extreme=",pdflo,pdfhi,"Error=",pdf68

scales=[]
for i in range(2,len(args)):
    print "Opening scale file:",args[i]
    s,e=getSigmaAndError(args[i])
    scales.append(s)
scales.sort()
scalesrange =  (scales[-1] - scales[0])/2.


print "---------------------"
print "Sigma=",sigma,"+/-(stat)",error,"+/-(pdf)",pdfrange,"+/-(scale)",scalesrange
print "---------------------"
