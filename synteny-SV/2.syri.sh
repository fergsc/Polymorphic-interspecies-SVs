#!/bin/bash

# After running nucmer we now want to run SyRI and find all
# syntenic regsion and rearrangements

genome1=""
genome2=""
minSimilarity=80
minLength=200
threads=


syriPath=""
mummerPath=""


delta="${spp1}~${spp2}_m_i${minSimilarity}_l${minLength}.delta"
coords="${spp1}~${spp2}_m_i${minSimilarity}_l${minLength}.coords"

python ${syriPath}/syri \
    -c $coords          \
    -r $genome1         \
    -q $genome2         \
    -d $delta           \
    --nc $threads       \
    -s ${mummerPath}/show-snps
