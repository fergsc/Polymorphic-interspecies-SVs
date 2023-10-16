#!/bin/bash

vcf=""
reference=""
threads=12

label=$(basename $vcf .vcf)
bcftools query -l $vcf > $label.txt

paragraph-2.4a/bin/multigrmpy.py \
    -i $vcf                      \
    -m $label.txt                \
    -r $reference                \
    -t $threads                  \
    -o $label
