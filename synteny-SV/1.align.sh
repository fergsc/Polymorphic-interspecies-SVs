#!/bin/bash

# Perfrom nucmer alignemnt
# Run on each genome pairing

genome1=""
genome2=""
minSimilarity=80
minLength=200

mummerPath=""

# split genome and run mulitple nucmer jobs
bash nucmer_bits.sh $genome1 $genome2 $minSimilarity $minLength 1 yes


spp1=$(basename $genome1 .fasta)
spp2=$(basename $genome2 .fasta)


# run show-coords, this is needed for syri.
${mummerPath}/show-coords -THrd ${spp1}~${spp2}_m_i${minSimilarity}_l${minLength}.delta > ${spp1}~${spp2}_m_i${minSimilarity}_l${minLength}.coords