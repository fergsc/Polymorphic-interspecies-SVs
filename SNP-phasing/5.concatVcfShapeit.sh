#!/bin/bash

bcfWild="/path/shapeit/*~phased.bcf"

ls -1 ${bcfWild} > bcf.txt
bcftools concat -l bcf.txt -O b > phased.bcf
bcftools index phased.bcf
