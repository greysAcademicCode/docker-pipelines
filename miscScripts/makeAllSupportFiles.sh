#!/usr/bin/env bash

# this script will delete all existing support files then re-build them from scratch

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P)

rm -rf "${THIS_DIR}/../genomeSize"
bash "$THIS_DIR/makeChromSizes.sh"

rm -rf "${THIS_DIR}/../inputData"
bash "$THIS_DIR/makeExampleData.sh"

rm -rf "${THIS_DIR}/../inputData"
bash "$THIS_DIR/makeVPlotIndex.sh"

rm -rf "${THIS_DIR}/../bowtie2Index"
bash "$THIS_DIR/makeBT2Index.sh"
