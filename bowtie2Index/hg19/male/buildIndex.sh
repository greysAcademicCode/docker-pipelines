#!/bin/bash

# this generates hg19 male  bowtie2 index files

# directory containing .fa files
SOURCE_FOLDER="/srv/gsfs0/projects/kundaje/users/akundaje/projects/encode/data/byDataType/sequence/encodeHg19Male"

# base output name
BT2_BASE="hg19male"

module load bowtie/2.2.4

bowtie2-build `ls -m  ${SOURCE_FOLDER}/*.fa | sed -e 's/, /,/g' | tr -d '\n'` $BT2_BASE

# you might consider submitting this job like this:
# qsub -wd `pwd` -l h_vmem=20G -o output.log -e error.log buildIndex.sh
