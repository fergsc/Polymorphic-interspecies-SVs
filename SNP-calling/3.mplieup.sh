#!/bin/bash

bam=""
reference=""
threads=4

sample=$(basename $bam .bam)

bcftools mpileup                                \
    --threads $threads                          \
    --redo-BAQ                                  \
    --max-depth 100000                          \
    --min-MQ 30                                 \
    --min-BQ 15                                 \
    --fasta-ref $genome                         \
    --annotate FORMAT/DP,FORMAT/AD,FORMAT/SP,INFO/AD \
    --output-type u                             \
    $(basename $bam)                            \
    | bcftools call                             \
    --threads $PBS_NCPUS                        \
    --multiallelic-caller                       \
    --variants-only                             \
    --prior 0.01                                \
    -O b                                        \
    -o ${sample}.bcf                            \
    &> ${sample}.log

bcftools index ${sample}.bcf
