#!/bin/bash

# this is an example script that generates hg19 female bowtie2 index files

# directory containing .fa files from the encode project
# I guess they canbe downloaded from here: http://hgdownload.cse.ucsc.edu/downloads.html#human
SOURCE_FOLDER="/srv/gsfs0/projects/kundaje/users/akundaje/projects/encode/data/byDataType/sequence/encodeHg19Female"

# base output name
BT2_BASE="hg19female"

module load bowtie/2.2.4

bowtie2-build `ls -m  ${SOURCE_FOLDER}/*.fa | sed -e 's/, /,/g' | tr -d '\n'` $BT2_BASE

# you might consider submitting this job like this:
# qsub -wd `pwd` -l h_vmem=20G -o output.log -e error.log buildIndex.sh
