#!/bin/bash

# copygain, i.e. genome B has the extra copy
# copyloss, i.e. genome A has the extra copy

[ -f data ] && rm -r data
mkdir data

syri="/.../syri.out"

echo "type,length,uID,species" > ref.csv
echo "type,length,uID,species" > qry.csv

grep -w 'DUP\|INV\|INVDP\|INVTR\|NOTAL\|SYN\|TRANS' $syri | \
    awk -v O=${qrySpp} '{if($2 == "-"){next;} if($12 == "copygain") {next;}
    if($2 < $3) {print $11 "," $3-$2 "," $9 "," O} else {print $11 "," $2-$3+1 "," $9 "," O} }' >> ref.csv

rep -w 'DUP\|INV\|INVDP\|INVTR\|NOTAL\|SYN\|TRANS' $syri | \
    awk -v O=${refSpp} '{if($8 == "-"){next;} if($12 == "copyloss") {next;}
    if($7 < $8) {print $11 "," $8-$7 "," $9 "," O} else {print $11 "," $7-$8+1 "," $9 "," O} }' >> qry.csv

