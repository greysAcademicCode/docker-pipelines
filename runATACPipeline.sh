#!/usr/bin/env bash
set -eu -o pipefail

# Usage:
# 1. place your fastq data files in to the inputData folder (as described below)
# 2. (optional) delete the example data files
# 3. run the pipeline by executing ./runATACPipeline.sh in your terminal
# 4. look for results to appear in a folder called ATACPipeOutput (the report .pdf file is probably what you want)

# NOTE: If you get an error when updating the docker image:
# "FATA[0002] Error: image greyson/pipelines:latest not found"
# then make sure that
# A: you're logged in with your docker user (run `docker login`)
# and
# B: Your docker user has permission to download the greyson/pipelines image (email grey@christoforo.net to ask)

# Setup some defaults
: ${USE_DOCKER:=true}
: ${MOUSE_MODEL:="mm10"}
: ${HUMAN_MODEL:="hg38"}

# pull the latest docker image (if needed)
#[ "$USE_DOCKER" = true ] && docker pull greyson/pipelines

# this is the absolute path to the directory of this script
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P)"

# this folder should contain subfolder(s) with named according to the species to be processed, i.e. "human and/or mouse"
# you put folders containing your two fastq input data files into these species folders
# each of the two fastq file names you use must uniquely match the patterns "*R1*fastq*" and "*R2*fastq*"
# so an example would be putting your two fastq input data files in a folder structure like this:
# inputData/mouse/trialA/billyTheMouse_R1_brain.fastq.gz
# inputData/mouse/trialA/billyTheMouse_R2_brain.fastq.gz
: ${DATA_FLDR:="${BASEDIR}/inputData"}

# path to directory containing vplot index files
: ${VINDEX_DIR:="${BASEDIR}/vPlotIndex"}

# path to pipelines repo directory (unused if running in docker mode)
: ${PIPELINES_REPO:="${BASEDIR}/pipelines"}

# path to directory containing size files
: ${SIZE_FILES:="${BASEDIR}/genomeSize"}

# path to bowtie 2 index directory
: ${BT2INDEX_DIR:="${BASEDIR}/bowtie2Index"}

# here is a folder that will get filled with directories containing output files for each experiment
: ${OUTPUT_DIR:="${BASEDIR}/ATACPipeOutput"}

# cpu threads to use
: ${THREADS:=1}
#THREADS=$(nproc)

#===========probably don't edit below here==========

# detect Windows
if [ -z ${MSYSTEM+x} ]; then
  WINDOWS=false
else
  WINDOWS=true
  export MSYS_NO_PATHCONV=1
  export MSYS2_ARG_CONV_EXCL="*"
  OUTPUT_DIR="$(echo "$OUTPUT_DIR" | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')"
fi

function process_data {
  echo "Processing $SPECIES_DIR..."
  for DATAPATH in "${SPECIES_DIR}"/*/ ; do
    echo
    echo "Found ${DATAPATH}"
    READ1FILE="$(find "${DATAPATH}" -type f -name *R1*fastq*)"
    echo "Using read #1 input file: $READ1FILE"
    READ2FILE="$(find "${DATAPATH}" -type f -name *R2*fastq*)"
    echo "Using read #2 input file: $READ2FILE"
    if [ -f "$READ1FILE" ] && [ -f "$READ2FILE" ]; then
      # compute some pipleine variables
      DATA_FOLDER="$(basename "${DATAPATH}")"
      OUTPUT_FOLDER="${OUTPUT_DIR}/${SPECIES}/${DATA_FOLDER}".output
      echo "Results will be stored in ${OUTPUT_FOLDER}"

      # delete the output folder (if it exists before we start)
      rm -rf "${OUTPUT_FOLDER}"

        # run the atac pipeline
        if [ "$USE_DOCKER" = true ] ; then
          DOCKER_IMAGE="greyson/pipelines:latest"
          docker stop atac >/dev/null 2>/dev/null || true
          docker rm atac >/dev/null 2>/dev/null || true
          docker pull ${DOCKER_IMAGE} || true
          R1NAME=$(basename $READ1FILE)
          R2NAME=$(basename $READ2FILE)
          DOCKER_OPTS="-v ${BT2INDEX_DIR}:/bt2 -v ${DATAPATH}:/data -v ${SIZEFILE}:/sizes -v ${VINDEXFILE}:/vindex --name atac -t ${DOCKER_IMAGE}"
          DOCKER_PREFIX="docker run ${DOCKER_OPTS}"
          echo
          echo "A Docker container will be used here. It will be run/setup in the following way:"
          eval echo '$DOCKER_PREFIX'
          #echo
          #echo "To enter the container interactively, use:"
          #eval echo "docker run -i ${DOCKER_OPTS} bash"
          RUN_PIPELINE='ATACpipeline.sh /bt2/${GENOME_MODEL} /data/${R1NAME} /data/${R2NAME} ${THREADS} ${MODEL} /sizes /vindex /output/${SPECIES}/${DATA_FOLDER}.output'
          echo "Now running the ATAC-Seq Pipeline inside a docker container with the following command:"
          
          eval echo "${RUN_PIPELINE}"
          echo
          eval ${DOCKER_PREFIX} ${RUN_PIPELINE}
           
          docker cp atac:/output/${SPECIES}/${DATA_FOLDER}.output "${OUTPUT_DIR}/${SPECIES}"
        else # don't use docker
          if [ ! -d "${PIPELINES_REPO}" ]; then
            echo "You need to get the pipelines repo"
            echo "Maybe: "
            exit
          fi
          pushd "${PIPELINES_REPO}"
          patch -r - --forward -p1 < ../pipelines.patch || true
          popd
          DOCKER_PREFIX=""
          if [ -z ${PICARD_HOME+x} ]; then
            :
          else
            export PICARDROOT="$PICARD_HOME"
          fi
          # add the pipeline scripts to PATH
          export PATH=$PATH:"${PIPELINES_REPO}"/atac
          RUN_PIPELINE='ATACpipeline.sh "${BT2INDEX}" "${READ1FILE}" "${READ2FILE}" ${THREADS} ${MODEL} "${SIZEFILE}" "${VINDEXFILE}" "${OUTPUT_FOLDER}"'
          echo "Now running the ATAC-Seq Pipeline with the following command:"
          eval echo "${RUN_PIPELINE}"
          echo
          eval ${DOCKER_PREFIX} ${RUN_PIPELINE}
        fi
        
        # split out reports to make them easier to find
        mkdir -p "${OUTPUT_DIR}/reports"
        cp "${OUTPUT_DIR}/${SPECIES}/${DATA_FOLDER}.output/${DATA_FOLDER}.output.report.pdf" "${OUTPUT_DIR}/reports/$SPECIES.${DATA_FOLDER}.output.report.pdf" || true
    else
      echo "Could not use the two input fastq data files."
    fi
  done
}

declare -a SPECIESES=("mouse" "human")
for SPECIES in "${SPECIESES[@]}"; do
  SPECIES_DIR="$DATA_FLDR/$SPECIES"
  if [ -d "$SPECIES_DIR" ]; then
    if [ "$SPECIES" = "mouse" ]; then
      GENOME_MODEL=$MOUSE_MODEL
      MODEL=mm
    fi
    if [ "$SPECIES" = "human" ]; then
      GENOME_MODEL=$HUMAN_MODEL
      MODEL=hs
    fi
    if [ -z "$MODEL" ]; then
      echo "$SPECIES not supported, skipping."
    else
      VINDEXFILE="${VINDEX_DIR}"/knownGene_${GENOME_MODEL}vPlotIndex.bed
      SIZEFILE="${SIZE_FILES}"/${GENOME_MODEL}.genome
      BT2INDEX="${BT2INDEX_DIR}"/${GENOME_MODEL}
      process_data
    fi
  else
    echo "$SPECIES_DIR does not exist, skipping"
  fi
done
