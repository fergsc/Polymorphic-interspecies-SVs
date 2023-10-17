refGenomeSize=
qryGenomeSize=
minSize=200

echo "reference,type,meanLength,sdLength,minCount,meanCount,maxCount,minPC,meanPC,maxPC" > overall/${minSize}.csv
for csv in *.csv
do
    reference=$(basename $csv .csv)
    [[ $reference == "ref" ]] && genomeSize=$refGenomeSize
    [[ $reference == "qry" ]] && genomeSize=$qryGenomeSize

    sed -e 's/INVDP/DUP/g ; s/INVTR/TRANS/g ' $csv > csv # group inverted dups with dups & inverted trans with trans.
    for type in NOTAL DUP INV SYN TRANS
    do
        awk -v M=$minSize -v T=${type} -v FS="," '$1 == T && $2 >= M {print $2}' csv > tmp
        meanLength=`awk '{sum += $1; count +=1} END{print int((sum/count)+.5)}' tmp`
        sdLength=`awk '{x+=$0; y+=$0^2} END{print int(0.5+sqrt(y/NR-(x/NR)^2))}' tmp`

        awk -v M=$minSize -v T=${type} -v FS="," '$1 == T && $2 >= M {print $4}' csv | awk '{print $1}' | sort | uniq -c| awk '{print $1}' > tmp
        minCount=`sort -h tmp | head -n 1`
        meanCount=`awk '{sum += $1; num+=1} END{print int((sum/num)+.5)}' tmp`
        maxCount=`sort -hr tmp | head -n 1`

        awk -v M=$minSize -v T=$type -v G=$genomeSize -v FS="," '$1 == T && $2 >= M {totals[$4] += $2} END{for(i in totals){print totals[i]/G}}' csv > tmp
        minPC=`sort -h tmp | head -n 1`
        meanPC=`awk '{sum += $1; num+=1} END{print sum/num}' tmp`
        maxPC=`sort -hr tmp | head -n 1`

        echo "$reference,$type,$meanLength,$sdLength,$minCount,$meanCount,$maxCount,$minPC,$meanPC,$maxPC" >> overall/${minSize}.csv
    done
done
rm tmp csv

