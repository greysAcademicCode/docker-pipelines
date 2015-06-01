#!/usr/bin/env bash

# This script downloads a compressed file containing a list of genes, then
# extracts the list, then
# picks out only the useful comumns and reorders them, sensative to the direction of the gene (+ or -), then
# removes underscores from chromasome names, then
# deletes any chromasome names not designated with a number or X or Y, then
# sorts the list, then
# removes duplicate lines and puts theindex file into a folder ./vPlotIndex

outdir="./vPlotIndex"

mkdir -p "${outdir}"

makeVplotIndex(){
model=$1
trackName=$2
saveDir=$3
curl  -s "http://hgdownload.cse.ucsc.edu/goldenPath/${model}/database/${trackName}.txt.gz" | gunzip -c | awk -v OFS='\t' '{if ($3 == "+") {print $2, $4, $4+1, $3} else {print $2, $5, $5+1, $3}}'| sed 's/_[^\t]*\t/\t/' | sed '/chr[0-9]\|chrX\|chrY/!d' | sort -V | uniq > "${saveDir}/${trackName}_${model}vPlotIndex.bed"
}

makeVplotIndex hg19 knownGene "${outdir}"
makeVplotIndex mm9 knownGene "${outdir}"
