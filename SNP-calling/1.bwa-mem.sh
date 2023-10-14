#!/bin/bash

reads=""
reference=""
threads=4
lib=""

sample=$(basename $reads .fastq.gz)
[[ ! -f $genome.fai ]]  && bwa index $genome

bwa mem -t $threads -p -R "@RG\\tID:${lib}~${sample}\\tSM:${sample}" $genome $reads \
    | samtools sort -m 4g -@ $threads - \
    > $sample.bam
samtools index $sample.bam
