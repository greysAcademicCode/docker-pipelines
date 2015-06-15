#!/usr/bin/env bash

# This script generates the support file .zip archive inside a docker container then copies it out

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker pull greyson/pipelines

docker stop atac >/dev/null 2>/dev/null
docker rm atac >/dev/null 2>/dev/null
docker run -v $THIS_DIR:/ATAC/miscScripts --name atac -t greyson/pipelines /ATAC/miscScripts/makeAllSupportFiles.sh
docker exec atac /ATAC/miscScripts/makeSupportFileZip.sh
docker cp atac:/ATAC/ATAC_support_files.zip $THIS_DIR/../ATAC_support_files.zip

#docker stop atac >/dev/null 2>/dev/null
#docker rm atac >/dev/null 2>/dev/null

