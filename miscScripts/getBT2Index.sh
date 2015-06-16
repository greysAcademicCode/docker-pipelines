#!/usr/bin/env bash

# this script downloads pre-build bt2 index files

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

URL_BASE='https://googledrive.com/host/0B6SEJBJh9kL3flNRQ2x3SWhCUU1RUjdNb0NBVmcxVkR0THF1VEhzSU9ZamxzOXA1VHhEOTg'

EXPECTED="$THIS_DIR/../bowtie2Index/filesExpected.txt"

cd "$THIS_DIR/../bowtie2Index"
while read line; do
  curl -L -O "$URL_BASE/${line}"
done <"$EXPECTED"
