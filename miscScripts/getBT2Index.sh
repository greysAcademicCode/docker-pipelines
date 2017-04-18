#!/usr/bin/env bash

# this script downloads pre-build bt2 index files

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

EXPECTED="$THIS_DIR/../bowtie2Index/filesExpected.txt"

cd "$THIS_DIR/../bowtie2Index"
while read line; do
  line=${line%$'\r'}
  pair=($line) # file name and download ID
  destination=${pair[0]}
  fileid=${pair[1]}
  echo "Downloading $destination"
  python "$THIS_DIR/googleDriveGetFile.py" $fileid $destination
  echo "Done."
done <"$EXPECTED"
