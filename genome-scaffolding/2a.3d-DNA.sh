#!/bin/bash

genome=""
nodups="juice/aligned/merged_nodups.txt.gz"
dnaDir=""

label="$(basename $genome .fasta)~3D-early"

mkdir ${label}
zcat $nodups > ${label}/$(basename $nodups .gz)
cd ${PBS_JOBFS}/${label}

bash ${ndaDir}/run-asm-pipeline.sh --editor-repeat-coverage --early-exit -i 1000 $genome $(basename $nodups .gz)
