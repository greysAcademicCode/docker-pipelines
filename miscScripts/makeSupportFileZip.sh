#!/usr/bin/env bash

# This script generates the support file .zip archive

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
OUT_ZIP="$THIS_DIR/../ATAC_support_files.zip"

zip -v -r "$OUT_ZIP" "$THIS_DIR/../bowtie2Index" "$THIS_DIR/../genomeSize" "$THIS_DIR/../inputData" "$THIS_DIR/../miscScripts" "$THIS_DIR/../README.md" "$THIS_DIR/../runATACPipeline.sh" "$THIS_DIR/../vPlotIndex"
