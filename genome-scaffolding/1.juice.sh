#!/bin/bash

R1=""
R2=""
GENOME=""
ENZYME=""
JuicerDir=""
threads=

fnaFile=$(basename $GENOME)
label=$(basename $GENOME .fasta)
mkdir juicer juicer/fastq
ln -s $R1 juicer/fastq/${label}_R1.fastq
ln -s $R2 juicer/fastq/${label}_R2.fastq
ln -s juicer/${GENOME} .
cd juicer

python3 ${juicerDir}/misc/generate_site_positions.py $ENZYME $label $fnaFile
bwa index $fnaFile
awk 'BEGIN{OFS="\t"}{print $1, $NF}' ${label}_${ENZYME}.txt > ${label}.chrom.sizes

${juicerDir}/scripts/juicer.sh -g $label -z $fnaFile -p ${label}.chrom.sizes -y  ${label}_${ENZYME}.txt -D /g/data/xe2/scott/gadi_modules/juicer-git -t $threads
${juicerDir}/CPU/common/cleanup.sh
