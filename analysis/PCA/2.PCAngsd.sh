#!/bin/bash

plinkPrefix=""
vectors="2"
threads=4

pcangsd               \
    -p ${plinkPrefix} \
    -e $vectors       \
    -t $threads       \
    -o ${plinkPrefix}.pcangsd
