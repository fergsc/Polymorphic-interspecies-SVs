#!/bin/bash

genome=""
nodups="juice/aligned/merged_nodups.txt.gz"
dnaDir=""
editRounds=2            # default=2
misjoinRepeatCoverage=5 # default=2

label="$(basename $genome .fasta)~${misjoinRepeatCoverage}-${editRounds}"

cd ${label}

bash ${ndaDir}/run-asm-pipeline-post-review.sh -g 100 --sort-output -s seal -i 1000 -r *.review.assembly $genome $nodups

