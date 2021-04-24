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
    # Set this to the DNS name of your development machine.
    # It should be the same as the domain portion of the URL 
    # in the Kconfig menu section:
    #   "Project OTA firmware config" -> "Firmware Upgrade URL"
    #
    # You can supply this as the first command-line argument,
    # or by setting the COMMON_NAME environment variable if 
    # you prefer.
    #
    # The ESP32 device will request OTA firmware updates at this
    # hostname, and it will expect the certificate to have been
    # generated first with that value in it, as well as your dev 
    # machine to be accessible at that network hostname.
    #
    # You can leave the default value as-is, as long as you can
    # modify your local network's DNS settings so that "esprog"
    # is a recognized hostname which is pointing at your dev
    # computer.

    COMMON_NAME=${COMMON_NAME:-"esprog"}
    if [ $# -ge 1 ]; then
      COMMON_NAME="$1"
    fi

    BUILD_DIR=${BUILD_DIR:-"build/"}
    CERTS_DIR=${CERTS_DIR:-"certs/"}

    BUILD_DIR_VAR_NAME="BUILD_DIR"
    CERTS_DIR_VAR_NAME="CERTS_DIR"

    BUILD_VAR_OUT=""
    CERTS_VAR_OUT=""

    pwd="$PWD"

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
        printf '%b\n' 'rm ca_cert.pem ca_key.pem; \
'"${BUILD_VAR_OUT} ${CERTS_VAR_OUT}"' \
'"${BASH_SOURCE[0]} ${COMMON_NAME}"
        echo ""
        return 1
    fi

    mkdir -p ${BUILD_DIR}

    cd ${BUILD_DIR}

    rm ca_cert.pem ca_key.pem 2>/dev/null || true

    # The certificate will only be valid for 1,000,000 years.
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
      -subj "/C=CA/ST=Unlisted/L=Unlisted/O=Unlisted/OU=Unlisted/CN=${COMMON_NAME}" \
      -keyout ca_key.pem -out ca_cert.pem

    chmod 600 ca_cert.pem

    cp ca_cert.pem ca_key.pem ../

    mkdir -p ../${CERTS_DIR}
    cp ca_cert.pem ../${CERTS_DIR}

    # Gen cert for config site.
    openssl req -newkey rsa:2048 -nodes -keyout ca_key_conf.pem -x509 -days 3650 -out ca_cert_conf.pem -subj "/CN=ESP32 HTTPS server epaper-idf"

    chmod 600 ca_cert_conf.pem

    cp ca_cert_conf.pem ca_key_conf.pem ../
    cp ca_cert_conf.pem ca_key_conf.pem ../${CERTS_DIR}

    cd "$pwd"
}

process_epaper_idf_gen_certs_args "$@"

epaper_idf_gen_certs "$@"
