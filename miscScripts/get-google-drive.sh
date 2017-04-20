#!/usr/bin/env bash
fileid="$1"
destination="$2"

# try to download the file
curl -c /tmp/cookie -L -o /tmp/probe.bin "https://drive.google.com/uc?export=download&id=${fileid}"
probeSize=`du -b /tmp/probe.bin | cut -f1`

# did we get a virus message?
# this will be the first line we get when trying to retrive a large file
bigFileSig='<!DOCTYPE html><html><head><title>Google Drive - Virus scan warning</title><meta http-equiv="content-type" content="text/html; charset=utf-8"/>'
sigSize=${#bigFileSig}

if (( probeSize <= sigSize )); then
  virusMessage=false
else
  firstBytes=$(head -c $sigSize /tmp/probe.bin)
  if [ "$firstBytes" = "$bigFileSig" ]; then
    virusMessage=true
  else
    virusMessage=false
  fi
fi

if [ "$virusMessage" = true ] ; then
  confirm=$(tr ';' '\n' </tmp/probe.bin | grep confirm)
  confirm=${confirm:8:4}
  curl -C - -b /tmp/cookie -L -o "$destination" "https://drive.google.com/uc?export=download&id=${fileid}&confirm=${confirm}"
else
  mv /tmp/probe.bin "$destination"
fi
