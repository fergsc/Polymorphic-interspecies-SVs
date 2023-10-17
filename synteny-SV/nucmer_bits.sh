#!/bin/bash

# parallelise nucmer jobs.

# break query fasta file into seperate fasta files
# one file per chromosome
# built up a list of nucmer jobs and
# use gnu parallel to run all nucmer jobs in parallel


[ $# < 6 ] && echo "Must specify: fastaRef + fastaQry (this gets split) + identity + length + seq per file + ?filt?" && exit 0
[ $# == 6 ] && filt=1 || filt=0

thread=11
export ncores_per_task=1


fnaRef=$1
fnaQry=$2
FILT_pc=$3
FILT_len=$4
bits=$5
pwd=`pwd`

NUCMER="/path to MUMmer3.23/nucmer"
FILTER="/path to MUMmer3.23/delta-filter"
COORDS="/path to MUMmer3.23/show-coords"

# nucmer parameters
L=40
B=500
C=200


fnaRefFile=$(basename $fnaRef)
fnaQryFile=$(basename $fnaQry)
spp1=${fnaRefFile%.*}
spp2=${fnaQryFile%.*}

# split qry fasta into parts
splitFasta.sh $fnaQry $bits


# check for existing nucerm and filter bash scripts, rm if exists
# build up nucmer and filter bash scripts
[ -f mum.sh ] && rm mum.sh
[ -f filt.sh ] && rm filt.sh
for fna in ${spp2}_bits/*.fasta
do
    file=$(basename $fna)
    run=${file%.*}
    i=`echo $run | cut -f2 -d'_'`

    echo "$NUCMER --maxmatch -l $L -b $B -c $C -p bit_${i} ${fnaRef} $fna" >> mum.txt
    echo "$FILTER -m -i $FILT_pc -l $FILT_len bit_${i}.delta" >> filt.txt
done

# run nucmer
echo "--- nucmer ---"
mpirun -np $((threads/ncores_per_task)) nci-parallel --input-file mum.txt


# combine nucmer out into a single file
echo "--- combining nucmer ---"
echo "$fnaRefFile $fnaQryFile" > ${spp1}~${spp2}.tmp
echo "NUCMER" >> ${spp1}~${spp2}.tmp
for d in `find . -maxdepth 1 -name 'bit*.delta'`
do
    awk 'NR > 2 {print $0}' $d >> ${spp1}~${spp2}.tmp
done
mv ${spp1}~${spp2}.tmp ${spp1}~${spp2}.delta

# if filtering alignement, then filter.
if [ $filt == 1 ]
then
    echo "--- delta-filter ---"
    mkdir filt
    mpirun -np $((threads/ncores_per_task)) nci-parallel --input-file filt.txt -o filt
    echo "$fnaRefFile $fnaQryFile" > ${spp1}~${spp2}_m_i${FILT_pc}_l${FILT_len}.delta
    echo "NUCMER" >> ${spp1}~${spp2}_m_i${FILT_pc}_l${FILT_len}.delta
    for d in `find filt/ -maxdepth 1 -name 'stdout.*'`
    do
        awk 'NR > 2 {print $0}' $d >> ${spp1}~${spp2}_m_i${FILT_pc}_l${FILT_len}.delta
    done
fi

# clean up
rm -r ${spp2}_bits mum.txt filt.txt bit*.*
