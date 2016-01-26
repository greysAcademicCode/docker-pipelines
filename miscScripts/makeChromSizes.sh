#!/usr/bin/env bash

# this script generates the chromosome size files for various models

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P)

declare -a MODELS=("mm9" "mm10" "hg19" "hg38")
OUT_DIR="${THIS_DIR}/../genomeSize"

mkdir -p "${OUT_DIR}"

for MODEL in "${MODELS[@]}"; do
  SAVE_FILE="${OUT_DIR}/${MODEL}.genome"
  echo "Genome size index for ${MODEL} and saving to ${SAVE_FILE}"...
  curl "http://hgdownload.cse.ucsc.edu/goldenPath/${MODEL}/bigZips/${MODEL}.chrom.sizes" | sed '/chr[0-9]\|chrM\|chrX\|chrY/!d' | sed '/_/d' > "${SAVE_FILE}"
  echo "Done!"
done
