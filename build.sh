#!/bin/bash
#
# epaper-idf
#
# Copyright (c) 2021 Jeremy Carter <jeremy@jeremycarter.ca>
#
# This code is released under the license terms contained in the
# file named LICENSE, which is found in the top-level folder in
# this project. You must agree to follow those license terms,
# otherwise you aren't allowed to copy, distribute, or use any 
# part of this project in any way.

epaper_idf_build() {
  VER_FILE=${VER_FILE:-"version.txt"}
  VER_MIC_FILE=${VER_MIC_FILE:-"version-micro.txt"}

  if [ -z ${IDF_PYTHON_ENV_PATH+x} ]; then
    echo ""
    echo "note: ESP-IDF has not been sourced yet. To speed things up, you can source it first by running the following command:"
    echo ""
    echo ". idf.env"
    echo ""
    echo "note: Sourcing ESP-IDF for you now..."
    echo ""
    . idf.env
  fi

  new_args=($(printf "$1\n" | sed -E 's/v//g' | sed -E 's/\./ /g'))

  set -- ${new_args[@]}

  if [ $# -ge 1 ]; then
    export EPAPER_IDF_VERSION_MAJOR=$1
  fi
  export EPAPER_IDF_VERSION_MAJOR=${EPAPER_IDF_VERSION_MAJOR:-0}

  if [ $# -ge 2 ]; then
    export EPAPER_IDF_VERSION_MINOR=$2
  fi
  export EPAPER_IDF_VERSION_MINOR=${EPAPER_IDF_VERSION_MINOR:-1}
  
  if [ $# -ge 3 ]; then
    export EPAPER_IDF_VERSION_MICRO=$3
  fi

  if [ ! -f "$VER_MIC_FILE" ]; then
    export EPAPER_IDF_VERSION_MICRO=${EPAPER_IDF_VERSION_MICRO:-0}
  else
    EPAPER_IDF_VERSION_MICRO_LAST=$(cat "$VER_MIC_FILE" | sed 's/[\s\n]//g')
    export EPAPER_IDF_VERSION_MICRO=${EPAPER_IDF_VERSION_MICRO:-$EPAPER_IDF_VERSION_MICRO_LAST}
  fi

  printf '%s' "$EPAPER_IDF_VERSION_MICRO" | tee "$VER_MIC_FILE" >/dev/null

  set -- ${1:-$EPAPER_IDF_VERSION_MAJOR} ${2:-$EPAPER_IDF_VERSION_MINOR} ${3:-$EPAPER_IDF_VERSION_MICRO}

  while [ $# -ge 1 ]; do
    if [ $# -le 1 ]; then
      mic=${1:-$EPAPER_IDF_VERSION_MICRO}
      shift
    elif [ $# -le 2 ]; then
      min=${1:-$EPAPER_IDF_VERSION_MINOR}
      shift
    elif [ $# -le 3 ]; then
      maj=${1:-$EPAPER_IDF_VERSION_MAJOR}
      shift  
    fi
  done
  
  export EPAPER_IDF_VERSION=${EPAPER_IDF_VERSION:-"v${maj}.${min}.${mic}"}

  printf '%s' "$EPAPER_IDF_VERSION" | tee "$VER_FILE" >/dev/null

  echo "Building EpaperIDF firmware version: ${EPAPER_IDF_VERSION}"

  # Build latest version of config site:
  cd components/epaper-idf-component/web
  ./build.sh
  cd ../../..

  # Copy sites for GitHub:
  rm -rf docs/
  cp -r public/ docs/
  cd components/epaper-idf-component
  rm -rf docs/
  cp -r public/ docs/
  cd ../..

  idf.py build

  echo
  echo "Built EpaperIDF firmware version: ${EPAPER_IDF_VERSION}"
}

epaper_idf_build $@
