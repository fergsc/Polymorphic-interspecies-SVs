#!/bin/bash

reference=""
bcf=""
minAC=""

bcftools norm               \
    --fasta-ref $reference  \
    --multiallelics -snps   \
    -O u                    \
    -o tmp.bcf              \
    $bcf

 bcftools view                    \
    -i 'QUAL >= 20 && INFO/AC >= $minAC && INFO/DP >= 20' \
    -O u                          \
    tmp.bcf                       \
    | bcftools norm               \
        --fasta-ref $reference    \
        --do-not-normalize        \
        --multiallelics +snps     \
        -O b                      \
        -o tmp2.bcf

bcftools index tmp2.bcf

bcftools view                       \
    -m 2 -M 2 -v snps               \
    -O b                            \
    -o $(basename $bcf)~bi-snps.bam \
    tmp2.bcf

bcftools index $(basename $bcf)~bi-snps.bam
bcftools stats -s - $(basename $bcf)~bi-snps.bam > $(basename $bcf)~bi-snps.stats
