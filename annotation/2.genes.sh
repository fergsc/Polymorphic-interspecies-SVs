#!/bin/bash

genome="" # soft masked from RepeatMasker
trainingData=""
threads=

# it may not be necessary to set all paths for braker, but for us it was.

braker.pl                                \
    --genome=$genome                     \
    --prot_seq=$trainingData             \
    --epmode                             \
    --softmasking                        \
    --cores=$threads                     \
    --species=$(basename $genome .fasta) \
    --gff3                               \
    --useexisting                        \
    --BAMTOOLS_PATH=                     \
    --SAMTOOLS_PATH=                     \
    --DIAMOND_PATH=                      \
    --BLAST_PATH=                        \
    --MAKEHUB_PATH=                      \
    --AUGUSTUS_CONFIG_PATH=              \
    --AUGUSTUS_BIN_PATH=                 \
    --AUGUSTUS_SCRIPTS_PATH=             \
    --GENEMARK_PATH=                     \
    --CDBTOOLS_PATH=                     \
    --PYTHON3_PATH=                      \
    --PROTHINT_PATH=


# GTF -> faa
/path-to-braker/bin/getAnnoFastaFromJoingenes.py -g $genome -f braker.gtf -o proteins.fa

