#!/bin/bash

# example Usage:
# USE_DOCKER=true ./runATACPipeline.sh ./inputData/human hg19

# update the docker image (if needed)
[ "$USE_DOCKER" = true ] && docker pull greyson/pipelines

BASEDIR="$(pwd)"

# path to directory containing vplot index files
VINDEX_DIR=${BASEDIR}/vPlotIndex/

# path to pipelines repo directory
PIPELINES_REPO=${BASEDIR}/pipelines/

# path to directory containing size files
SIZE_FILES=${BASEDIR}/genomeSize/

# path to bowtie 2 index directory
BT2INDEX_DIR=${BASEDIR}/bowtie2Index/

# here is a folder that will get filled with directories containing output files for each experiment
OUTPUT_DIR=${BASEDIR}/ATACPipeOutput/

# this folder should contain one or more folders each containing two fastq files
INPUT_DIR=$1
INPUT_DIR=$(readlink -f $INPUT_DIR)

# genome model to match against (could be mm9 or hg19, etc.)
#GENOME_MODEL=mm9
GENOME_MODEL=$2
GENDER=male

# threads to use for alignment
THREADS=4

# the following is generally not user editable

if [[ $GENOME_MODEL == *"hg"* ]]; then
  MODEL=hs
elif [[ $GENOME_MODEL == *"mm"* ]]; then
  MODEL=mm
else
  echo "Could not match genome model"
  exit 1
fi

# add the pipeline scripts to PATH
if [ "$USE_DOCKER" != true ] ; then
  export PATH=$PATH:"${PIPELINES_REPO}"/atac
fi

VINDEXFILE="${VINDEX_DIR}"/knownGene_${GENOME_MODEL}vPlotIndex.bed
SIZEFILE="${SIZE_FILES}"/${GENOME_MODEL}.genome
BT2INDEX="${BT2INDEX_DIR}"/${GENOME_MODEL}/${GENDER}/${GENOME_MODEL}${GENDER}

for DATAPATH in "${INPUT_DIR}"/*/ ; do
  echo "Processing ${DATAPATH}"

  # compute some pipleine variables
  DATA_FOLDER=$(basename "${DATAPATH}")
  OUTPUT_FOLDER="${OUTPUT_DIR}"/"${DATA_FOLDER}".output

  # delete the output folder (if it exists before we start)
  rm -rf "${OUTPUT_FOLDER}"

  # input data files MUST have "R1" or "R2" before "fastq" in their file names
  READ1FILE=$(find "${DATAPATH}" -type f -name *R1*fastq*)
  READ2FILE=$(find "${DATAPATH}" -type f -name *R2*fastq*)

  # run the atac pipeline
  if [ "$USE_DOCKER" = true ] ; then
    docker stop atac
    docker rm atac
    DOCKER_PREFIX="docker run -v ${BT2INDEX}:${BT2INDEX} -v ${READ1FILE}:${READ1FILE} -v ${READ2FILE}:${READ2FILE} -v ${SIZEFILE}:${SIZEFILE} -v ${VINDEXFILE}:${VINDEXFILE} --name atac -t greyson/pipelines"
  fi
  $DOCKER_PREFIX ATACpipeline.sh "${BT2INDEX}" "${READ1FILE}" "${READ2FILE}" ${THREADS} ${MODEL} "${SIZEFILE}" "${VINDEXFILE}" "${OUTPUT_FOLDER}"
  # [ "$USE_DOCKER" = true ] && docker cp atac:"${OUTPUT_FOLDER}" "${OUTPUT_FOLDER}"
  # chmod -R o+r "${OUTPUT_FOLDER}"
  # echo ATACpipeline.sh "${BT2INDEX}" "${READ1FILE}" "${READ2FILE}" ${THREADS} ${MODEL} "${SIZEFILE}" "${OUTPUT_FOLDER}"
done
