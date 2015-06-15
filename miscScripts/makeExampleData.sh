#!/usr/bin/env bash

# this script fetches and trims example data files for mouse and human
# note that the curl error (23) is to be expected (we're aborting huge downloads prematurely here)

HUMAN_SOURCE_1='ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR182/008/SRR1822168/SRR1822168_1.fastq.gz'
HUMAN_SOURCE_2='ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR182/008/SRR1822168/SRR1822168_2.fastq.gz'
MOUSE_SOURCE_1='ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR193/000/SRR1930170/SRR1930170_1.fastq.gz'
MOUSE_SOURCE_2='ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR193/000/SRR1930170/SRR1930170_2.fastq.gz'

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P)

MOUSE_OUT="$THIS_DIR/../inputData/mouse/example"
mkdir -p "$MOUSE_OUT"
curl $MOUSE_SOURCE_1 | gunzip -c | head -1000000 | tail -100000 > "$MOUSE_OUT/R1.snipped.fastq"
curl $MOUSE_SOURCE_2 | gunzip -c | head -1000000 | tail -100000 > "$MOUSE_OUT/R2.snipped.fastq"

HUMAN_OUT="$THIS_DIR/../inputData/human/example"
mkdir -p "$HUMAN_OUT"
curl $HUMAN_SOURCE_1 | gunzip -c | head -1000000 | tail -100000 > "$HUMAN_OUT/R1.snipped.fastq"
curl $HUMAN_SOURCE_2 | gunzip -c | head -1000000 | tail -100000 > "$HUMAN_OUT/R2.snipped.fastq"
