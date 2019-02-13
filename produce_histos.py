import os,sys

from optparse import OptionParser

usage='''
   %prog  file
'''
parser=OptionParser(usage=usage)
#parser.add_option("-p","--pdf",action='store_true',help="loop over pdfs files",default=False)
parser.add_option("-o","--outname",help="Output file name [%default]",default="mll.root")
opts,args=parser.parse_args()

import ROOT


def ProduceHistogram(L):
    ''' Given the list produce a Histogram, and a TGraph'''
    print "Parsing",len(L), "entries"
    L.sort()
    g=ROOT.TGraph()
    g.SetName("g_mll")
    print "DEBUG","L[0]",L[0]
    h=ROOT.TH1D("h_mll","h_mll",len(L),L[0][2],L[-1][3]) ## I would need to change it to variable binning
    for xc, xs, low, high in L:
        g.SetPoint(g.GetN(),xc,xs)
        h.SetBinContent( h.FindBin(xc),xs)
    return g,h


def ReadFile(fname):
    print "-> Parsing file",fname
    fin =open(fname,"r")
    isMll=False 
    R=[]

    mllmin=None
    mllmax=None

    for line in fin:
        if mllmin == None and 'Lepton-pair invariant mass minimum' in line:
            mllmin=float(line.split('=')[1])
            print "* MLLmin is",mllmin
            continue
        if mllmax == None and 'Lepton-pair invariant mass maximum' in line:
            mllmax=float(line.split('=')[1])
            print "* MLLmax is",mllmax
            continue
        if 'Q_ll Inv' in line and '----' in line: 
            isMll=True
            print "* Parsing Mll"
            continue
        elif '----' in line and isMll: break ## spead up
        elif '----' in line: isMll=False

        if isMll:
            parts=line.split()
            if len(parts)< 3 : continue
            xc = float(parts[0])
            xs = float(parts[1])

            if len(R) >0: # change last mllmax, (xc + xc)/2
                lowbound=(xc + R[-1][0])/2.
                R[-1][3]=lowbound
            else: lowbound=mllmin
            R.append( [xc, xs, lowbound, mllmax] ) 

    return R

L=[]
for fname in args:
    L.extend(ReadFile(fname))
fOut=ROOT.TFile.Open(opts.outname,"RECREATE")
g,h=ProduceHistogram(L)
g.Write()
h.Write()
fOut.Close()
