#!/bin/bash

bcf="whatshap/XXX-Chr09.bcf"
threads=12

[[ ! -f ${bcf}.csi ]] && bcftools index $bcf
region=`echo $(basename $bcf .bcf) | cut -f2 -d'-'` # whole chromosome
label=$(basename $bcf .bcf)

shapeit4.2                                       \
    -T $threads                                  \
    -I $label.bcf                                \
    --region $region                             \
    --sequencing                                 \
    --use-PS 0.0001                              \
    --mcmc-iterations 6b,1p,1b,1p,1b,1p,1b,1p,8m \
    --pbwt-depth 6                               \
    --log ${label}.log                           \
    -O ${label}~phased.bcf

# --sequencing = we are using high density SNPs - sequecning data not SNP chip
# --use-PS = whatshapo was run previously, phasing some snps and leaving PS scores
# --mcmc-iterations = use more time and get more accuracy
# --pbwt-depth = use more time and get more accuracy

