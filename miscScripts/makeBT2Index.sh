#!/usr/bin/env bash

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

declare -a MODELS=("mm9" "mm10" "hg19" "hg38")

OUT_DIR="${THIS_DIR}/../bowtie2Index"
SOURCE_DIR="${OUT_DIR}/sourceFA"

SIZE_FILE_DIR="${THIS_DIR}/../genomeSize"

for MODEL in "${MODELS[@]}"; do
  while IFS=$'\t' read -r -a values
  do
    CHROM="${values[0]}"
    echo "Building bowtie2 index for $MODEL, $CHROM..."
    mkdir -p "$SOURCE_DIR/$MODEL"
    cd "$SOURCE_DIR/$MODEL"
    [ ! -f "$CHROM.fa" ] && wget http://hgdownload.cse.ucsc.edu/goldenPath/$MODEL/chromosomes/$CHROM.fa.gz
    [ ! -f "$CHROM.fa" ] && gunzip "$CHROM.fa.gz"
  done < "$SIZE_FILE_DIR/${MODEL}.genome" 
  FA_LIST="$(ls -t *.fa | tr '\n' ',')"
  FA_LIST=${FA_LIST::-1}
  echo $FA_LIST
  bowtie2-build $FA_LIST $MODEL
  mv $MODEL* $OUT_DIR/
done
rm -rf ${SOURCE_DIR}
