#!/bin/bash

reference=""
threads=1
bcfDir=""

bcftools merge                           \
    --threads $threads                   \
    -o $(basename $reference .fasta).bcf \
    -O b                                 \
    $bcfDir/*.bcf

bcftools index $(basename $reference .fasta).bcf
