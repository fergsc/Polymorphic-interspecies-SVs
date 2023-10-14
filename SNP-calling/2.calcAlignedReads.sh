#!/bin/bash

bam=$1
sample=$(basename $bam .bam)

samtools view $bam | bioawk -c sam -v sample=$sample '
    BEGIN{print "sample,totalReads,aligned,alignedPC"}
    {
        totalReads+=1;
        if(!and($flag,4)){aligned+=1}
    }
    END{print sample "," totalReads "," aligned "," aligned/totalReads}'

