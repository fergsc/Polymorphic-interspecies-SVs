#!/bin/bash

whatshapDir=""

runName=$(basename $whatshapDir)

# merge results from whatsHap into a single bcf.
bcftools merge whatshapDir/*.bcf -O b > $runName.bcf
bcftools index $runName.bcf


# seperate bcf into chromosomes, batch for ShapeIt
for chr in `bcftools query -l $runName.bcf`
do
    bcftools view -r $chr -O b $runName.bcf > ${runName}~${chr}.bcf
    bcftools index ${runName}~${chr}.bcf
done

