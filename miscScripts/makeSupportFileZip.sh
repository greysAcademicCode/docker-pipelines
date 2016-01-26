#!/usr/bin/env bash

# This script generates the support file .zip archive

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
OUT_ZIP="ATAC_support_files.zip"
cd "$THIS_DIR/.."
zip -v -r "$OUT_ZIP" "bowtie2Index" "genomeSize" "inputData" "miscScripts" "README.md" "runATACPipeline.sh" "vPlotIndex"
