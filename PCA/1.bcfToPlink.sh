#!/bin/bash

bcf=""

plink  --make-bed --allow-extra-chr \
    --bcf $bcf                      \
    -out $(basename $bcf .bcf)
