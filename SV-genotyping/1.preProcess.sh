#!/bin/bash

syriFile=""
referenceA=""
referenceB=""


labelA=$(basename $referenceA .fasta)
labelB=$(basename $referenceB .fasta)

### take SyRI output and get events to add to vcf for genotyping.
# use: inversions, duplications/inverted duplications, translocations/inverted translocations
# copygain, i.e. genome B has the extra copy
# copyloss, i.e. genome A has the extra copy
# awk BEGIN needs to be set up with your chromosome sizes.

awk -v OFS='\t' 'BEGIN{gne["Chr01"]=47521758;gne["Chr02"]=59605212;gne["Chr03"]=75244271;gne["Chr04"]=41898641;gne["Chr05"]=68120194;gne["Chr06"]=59474948;gne["Chr07"]=58774262;gne["Chr08"]=79483852;gne["Chr09"]=43806378;gne["Chr10"]=42838711;gne["Chr11"]=47170705}
    {
        if($2>=150 && $3<=(gne[$1]-150))
        {
            if($12 == "copygain"){next}
            print $1,$2,$3,$9,$11
        }
    }' $syriFile | grep -w 'INV\|DUP\|TRANS\|INVDP\|INVTR' |sort -k1V -k2V > $labelA.tsv

awk -v OFS='\t' 'BEGIN{gne["Chr01"]=41762384;gne["Chr02"]=62687679;gne["Chr03"]=60475194;gne["Chr04"]=38789450;gne["Chr05"]=61769352;gne["Chr06"]=59036187;gne["Chr07"]=64903615;gne["Chr08"]=68532434;gne["Chr09"]=39568849;gne["Chr10"]=42233372;gne["Chr11"]=41443258}
    {
        if($7>=150 && $8<=(gne[$6]-150))
        {
            if($12 == "copyloss"){next}
            print $6,$7,$8,$9,$11
        }
    }' $syriFile | grep -w 'INV\|DUP\|TRANS\|INVDP\|INVTR' |sort -k1V -k2V > $labelB.tsv

# treat NOTAL as deletions
awk -v OFS='\t' 'BEGIN{gne["Chr01"]=47521758;gne["Chr02"]=59605212;gne["Chr03"]=75244271;gne["Chr04"]=41898641;gne["Chr05"]=68120194;gne["Chr06"]=59474948;gne["Chr07"]=58774262;gne["Chr08"]=79483852;gne["Chr09"]=43806378;gne["Chr10"]=42838711;gne["Chr11"]=47170705}
    {if($11 != "NOTAL"){next}
    if($2 == "-"){next}
    if($2<=150 || $3>=(gne[$1]-150)){next}
    if(($3-$2) < 200){next}
    print $1,$2,$3,$9,$11}' $syriFile |sort -k1V -k2V >> $labelA.tsv

awk -v OFS='\t' 'BEGIN{gne["Chr01"]=41762384;gne["Chr02"]=62687679;gne["Chr03"]=60475194;gne["Chr04"]=38789450;gne["Chr05"]=61769352;gne["Chr06"]=59036187;gne["Chr07"]=64903615;gne["Chr08"]=68532434;gne["Chr09"]=39568849;gne["Chr10"]=42233372;gne["Chr11"]=41443258}
    {if($11 != "NOTAL"){next}
    if($7 == "-"){next}
    if($7<=150 || $8>=(gne[$6]-150)){next}
    if(($8-$7) < 200){next}
    print $6,$7,$8,$9,$11}' $syriFile |sort -k1V -k2V >> $labelB.tsv

####
# make paragraph compatible vcf.
python3 syri2paragraph.py mell.fasta mell-syri.tsv mell-syri.vcf
python3 syri2paragraph.py sider.fasta sider-syri.tsv sider-syri.vcf
