#!/bin/bash

bcf=""
threads=12

# build list of bash commands
bcftools query -l $bcf | awk -v bcf=$bcf '{print "bcftools view -s " $1 " -O b -o " D "/" $1 ".bcf " bcf}' > commands.txt

# execute bash commands
parallel -j $threads  < commands.txt


### when used on the NCI HPC Gadi
# module load nci-parallel/1.0.0
# export ncores_per_task=1
# mpirun -np $((PBS_NCPUS/ncores_per_task)) nci-parallel --input-file commands.txt

