import sys
from Bio import SeqIO
import pandas as pd

##########
### get file names
fnaFile = sys.argv[1]    # reference genome
regionList = sys.argv[2] # tsv from syri with regions to add to vcf
                         # chrom,start,end,id,type
saveFile = sys.argv[3]   # xxx.vcf

# cycle though regions and collate into chroms
if regionList.endswith(".tsv"):
    regionDf = pd.read_csv(regionList, sep='\t', header=None)
if regionList.endswith(".csv"):
    regionDf = pd.read_csv(regionList, sep=',', header=None)

regionDf.columns = ["chrom","start","end","id", "type"]
regionGroups = regionDf.groupby('chrom').groups
regionDf['start'] = regionDf['start']-1

outputVcf = []
with open(fnaFile, "r") as fna:
    for record in SeqIO.parse(fna, "fasta"):
        if record.id in regionGroups:
            for currIdx in regionGroups[record.id]:
                currRegion = regionDf.iloc[currIdx]
                event = str(record.seq[currRegion['start']: currRegion['end']])
                if currRegion['type'] == "INV":
                    event2 = str(record.seq[currRegion['start']: currRegion['end']].reverse_complement())
                    outputVcf.append([record.id, currRegion['start']+1, currRegion['id'], event, event[0] + event2, ".", ".", "END={}".format(currRegion['end'])])
                if currRegion['type'] in  ["DUP", "INVDP", "TRANS", "INVTR", "NOTAL"]:
                    outputVcf.append([record.id, currRegion['start']+1, currRegion['id'], event, event[0], ".", ".", "END={}".format(currRegion['end'])])

vcfDf = pd.DataFrame(outputVcf)
vcfDf.to_csv(saveFile, sep='\t', header=None, index=False)
