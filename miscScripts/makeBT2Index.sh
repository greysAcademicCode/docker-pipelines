#!/usr/bin/env bash

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

declare -a MODELS=("mm9" "mm10" "hg19" "hg38")

OUT_DIR="${THIS_DIR}/../bowtie2Index"
SOURCE_DIR="${OUT_DIR}/sourceFA"

SIZE_FILE_DIR="${THIS_DIR}/../genomeSize"

for MODEL in "${MODELS[@]}"; do
  echo "FOR $MODEL"
  while IFS=$'\t' read -r -a values
  do
    CHROM="${values[0]}"
    mkdir -p "$SOURCE_DIR/$MODEL"
    rsync -a -P rsync://hgdownload.cse.ucsc.edu/goldenPath/$MODEL/chromosomes/$CHROM.fa.gz "$SOURCE_DIR/$MODEL/"
    [ ! -f "$SOURCE_DIR/$MODEL/$CHROM.fa" ] && gunzip "$SOURCE_DIR/$MODEL/$CHROM.fa.gz"
  done < "$SIZE_FILE_DIR/${MODEL}.genome"
done
