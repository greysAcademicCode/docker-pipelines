#!/usr/bin/env bash

# use UDR to (greatly) speed up downloads, if you don't have udr installed, set this to zero
SUPER_FAST_DOWNLOAD=true

if [ "$SUPER_FAST_DOWNLOAD" = true ] ; then
  udr --version > /dev/null 2> /dev/null
  if [ "$?" = 1 ] ; then
    echo "Using UDR"
  else
   echo "set SUPER_FAST_DOWNLOAD=false or install UDR"
   exit
  fi
fi

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
    if [ "$SUPER_FAST_DOWNLOAD" = true ] ; then
      udr rsync -avP hgdownload.cse.ucsc.edu::goldenPath/$MODEL/chromosomes/$CHROM.fa.gz .
      gunzip -c $CHROM.fa.gz > "$CHROM.fa"
      rm $CHROM.fa.gz
    else
      curl http://hgdownload.cse.ucsc.edu/goldenPath/$MODEL/chromosomes/$CHROM.fa.gz | gunzip -c > "$CHROM.fa"
    fi
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
