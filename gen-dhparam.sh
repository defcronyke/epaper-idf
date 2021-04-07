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

process_epaper_idf_gen_dhparam_args() {
    epaper_idf_script_args=()

    for arg in "$@"; do
        epaper_idf_script_args+=("${arg}")
    done

    set -- "${epaper_idf_script_args[@]}"

    export EPAPER_IDF_SCRIPT_ARGS=$@
}

epaper_idf_gen_dhparam() {
    pwd="$PWD"
    BUILD_DIR=${BUILD_DIR:-"build/"}

    BUILD_DIR_VAR_NAME="BUILD_DIR"
    BUILD_VAR_OUT=""
    
    if [ ! -z ${BUILD_DIR+x} ]; then
        BUILD_VAR_OUT="${BUILD_DIR_VAR_NAME}=\"${BUILD_DIR}\""
    fi

    if [ -f "dhparam.pem" ]; then
        echo "error: You already have a \"./dhparam.pem\" file. \
Delete it first and then run this script again if you want to \
generate a new file, for example:"
        echo ""
        echo "rm dhparam.pem; ${BUILD_VAR_OUT} ${BASH_SOURCE[0]}"
        echo ""
        return 1
    fi

    mkdir -p ${BUILD_DIR}

    cd ${BUILD_DIR}

    openssl dhparam -out dhparam.pem 4096
    chmod 600 dhparam.pem

    cp dhparam.pem ../

    cd "$pwd"
}

process_epaper_idf_gen_dhparam_args "$@"

epaper_idf_gen_dhparam "$@"
