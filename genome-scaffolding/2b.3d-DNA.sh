#!/bin/bash

genome=""
nodups="juice/aligned/merged_nodups.txt.gz"
dnaDir=""
editRounds=2            # default=2
misjoinRepeatCoverage=5 # default=2

label="$(basename $genome .fasta)~${misjoinRepeatCoverage}-${editRounds}"

mkdir ${label}
zcat $nodups > ${label}/$(basename $nodups .gz)
cd ${label}

bash ${ndaDir}/run-asm-pipeline.sh --editor-repeat-coverage $misjoinRepeatCoverage -r $editRounds -i 1000 $genome $(basename $nodups .gz)
