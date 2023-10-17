#!/bin/bash

codingSeqs=""
threads=

emapper.py                       \
    -m diamond                   \
    -i $codingSeqs               \
    --itype CDS                  \
    --cpu $threads               \
    --tax_scope Viridiplantae    \
    -o $(basename $codingSeqs .fa)
