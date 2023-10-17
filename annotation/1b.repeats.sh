#!/bin/bash

genome=""
threads=
label=$(basename $genome .fasta)
TELib="EDTA/${label}.fasta.mod.EDTA.TElib.fa"

RepeatMasker     \
    -pa $threads \
    -s           \
    -lib $TELib  \
    -dir repeats \
    -e ncbi      \
    $genome
