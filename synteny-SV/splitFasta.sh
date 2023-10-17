#!/bin/bash

# split fasta file into smaller fasta/q files with 1 sequence in each
# this is used as part of parallelise nucmer.

[ $# != 2 ] && echo "Must specify: fasta + number of seq per file" && exit 0

fna=$1
chrPrefix=$2

awk -v chrPrefix=$chrPrefix 'BEGIN{chrPrefix=">"chrPrefix}
{
    if($1~chrPrefix){seqName=substr($1,2); next}
    print ">"seqName "\n" $0 > seqName".fasta"
}' $fna
