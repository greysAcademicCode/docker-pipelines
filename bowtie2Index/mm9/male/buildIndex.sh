#!/bin/bash

# this generates bowtie2 index files for mm9

SOURCE_FOLDER="/srv/gsfs0/projects/kundaje/users/akundaje/projects/encode/data/byDataType/sequence/mm9"
BT2_BASE="mm9"

module load bowtie/2.2.4

bowtie2-build `ls -m  ${SOURCE_FOLDER}/*.fa | sed -e 's/, /,/g' | tr -d '\n'` $BT2_BASE
