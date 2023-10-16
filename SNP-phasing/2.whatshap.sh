#!/bin/bash

bcfDir=""
bamDir=""
reference=""
threads=12

# build list of bash commands
for bcf in ${bcfDir}/*.bcf
do
    sample=$(basename $bcf .bcf)
    echo "whatshap phase -o ${sample}.vcf --reference $reference $bcf $bamDir/${sample}.bam" >> commands.txt
done

# execute bash commands
parallel -j $threads  < commands.txt



### when used on the NCI HPC Gadi
# module load nci-parallel/1.0.0
# export ncores_per_task=1
# mpirun -np $((PBS_NCPUS/ncores_per_task)) nci-parallel --input-file commands.txt
