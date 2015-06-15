#!/usr/bin/env bash

# This script downloads a compressed file containing a list of genes, then
# extracts the list, then
# picks out only the useful comumns and reorders them, sensative to the direction of the gene (+ or -), then
# removes underscores from chromasome names, then
# deletes any chromasome names not designated with a number or X or Y, then
# sorts the list, then
# removes duplicate lines and puts theindex file into a folder ../vPlotIndex

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P)

declare -a MODELS=("mm9" "mm10" "hg19" "hg38")
TRACK_NAME="knownGene"
OUT_DIR="${THIS_DIR}/../vPlotIndex"

mkdir -p "${OUT_DIR}"

for MODEL in "${MODELS[@]}"; do
  SAVE_FILE="${OUT_DIR}/${TRACK_NAME}_${MODEL}vPlotIndex.bed"
  echo "Making V-Plot index for $MODEL, $TRACK_NAME and saving to $SAVE_FILE..."
  curl "http://hgdownload.cse.ucsc.edu/goldenPath/${MODEL}/database/${TRACK_NAME}.txt.gz" | gunzip -c | awk -v OFS='\t' '{if ($3 == "+") {print $2, $4, $4+1, $3} else {print $2, $5, $5+1, $3}}'| sed 's/_[^\t]*\t/\t/' | sed '/chr[0-9]\|chrX\|chrY/!d' | sort -V | uniq > "$SAVE_FILE"
  echo Done!
done
