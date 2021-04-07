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

process_epaper_idf_gen_certs_args() {
    epaper_idf_script_args=()

    for arg in "$@"; do
        epaper_idf_script_args+=("${arg}")
    done

    set -- "${epaper_idf_script_args[@]}"

    export EPAPER_IDF_SCRIPT_ARGS=$@
}

epaper_idf_gen_certs() {
    pwd="$PWD"

    BUILD_DIR=${BUILD_DIR:-"build/"}
    CERTS_DIR=${CERTS_DIR:-"certs/"}

    BUILD_DIR_VAR_NAME="BUILD_DIR"
    CERTS_DIR_VAR_NAME="CERTS_DIR"

    BUILD_VAR_OUT=""
    CERTS_VAR_OUT=""

    if [ ! -z ${BUILD_DIR+x} ]; then
        BUILD_VAR_OUT="${BUILD_DIR_VAR_NAME}=\"${BUILD_DIR}\""
    fi

    if [ ! -z ${CERTS_DIR+x} ]; then
        CERTS_VAR_OUT="${CERTS_DIR_VAR_NAME}=\"${CERTS_DIR}\""
    fi

    if [ -f "ca_cert.pem" ] || [ -f "ca_key.pem" ]; then
        echo "error: You already have \"./ca_cert.pem\" and \"ca_key.pem\" files. \
Delete them first and then run this script again if you want to \
generate new files, for example:"
        echo ""
        echo "rm ca_cert.pem; rm ca_key.pem; ${BUILD_VAR_OUT} ${CERTS_VAR_OUT} ${BASH_SOURCE[0]}"
        echo ""
        return 1
    fi

    mkdir -p ${BUILD_DIR}

    cd ${BUILD_DIR}

    rm ca_cert.pem ca_key.pem 2>/dev/null || true

    # The certificate will only be valid for 1,000,000 years.
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
      -subj "/C=US/ST=Unlisted/L=Unlisted/O=Unlisted/OU=Unlisted/CN=esprog" \
      -keyout ca_key.pem -out ca_cert.pem

    chmod 600 ca_cert.pem

    cp ca_cert.pem ca_key.pem ../

    mkdir -p ../${CERTS_DIR}
    cp ca_cert.pem ../${CERTS_DIR}

    cd "$pwd"
}

process_epaper_idf_gen_certs_args "$@"

epaper_idf_gen_certs "$@"
