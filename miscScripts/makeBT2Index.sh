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
    echo "Fetching fasta sequences for $MODEL, $CHROM..."
    mkdir -p "$SOURCE_DIR/$MODEL"
    cd "$SOURCE_DIR/$MODEL"
    curl http://hgdownload.cse.ucsc.edu/goldenPath/$MODEL/chromosomes/$CHROM.fa.gz | gunzip -c > "$CHROM.fa"
  done < "$SIZE_FILE_DIR/${MODEL}.genome" 
  FA_LIST="$(ls -t *.fa | tr '\n' ',')"
  FA_LIST=${FA_LIST::-1}
  echo "Building $MODEL bowtie2 index..."
  bowtie2-build $FA_LIST $MODEL
  mv $MODEL* "$OUT_DIR/"
done
rm -rf ${SOURCE_DIR}
cd "$OUT_DIR"
ls -1 *.bt2 > filesExpected.txt
