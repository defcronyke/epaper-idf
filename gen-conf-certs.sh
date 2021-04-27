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

process_epaper_idf_gen_conf_certs_args() {
    epaper_idf_script_args=()

    for arg in "$@"; do
        epaper_idf_script_args+=("${arg}")
    done

    set -- "${epaper_idf_script_args[@]}"

    export EPAPER_IDF_SCRIPT_ARGS=$@
}

epaper_idf_gen_conf_certs() {
    # Set this to the DNS name of your epaper-idf device.
    # It should be the same as the value in the Kconfig menu 
    # section (default value is "epaper"):
    #
    #   "Component config" -> "LWIP" -> "Local netif hostname"
    #
    # You can supply this as the first command-line argument,
    # or by setting the COMMON_NAME_CONF environment variable if 
    # you prefer.
    #
    # You can leave the default value as-is, as long as you didn't 
    # change the value in the Kconfig menu.

    COMMON_NAME_CONF=${COMMON_NAME_CONF:-"epaper"}
    if [ $# -ge 1 ]; then
      COMMON_NAME_CONF="$1"
    fi

    COMMON_IP_CONF=${COMMON_IP_CONF:-"126.233.53.78"}
    if [ $# -ge 2 ]; then
      COMMON_IP_CONF="$2"
    fi

    BUILD_DIR_CONF=${BUILD_DIR_CONF:-"build/"}
    CERTS_DIR_CONF=${CERTS_DIR_CONF:-"certs/"}

    BUILD_DIR_VAR_NAME_CONF="BUILD_DIR_CONF"
    CERTS_DIR_VAR_NAME_CONF="CERTS_DIR_CONF"

    BUILD_VAR_OUT_CONF=""
    CERTS_VAR_OUT_CONF=""

    pwd="$PWD"

    if [ ! -z ${BUILD_DIR_CONF+x} ]; then
        BUILD_VAR_OUT_CONF="${BUILD_DIR_VAR_NAME_CONF}=\"${BUILD_DIR_CONF}\""
    fi

    if [ ! -z ${CERTS_DIR_CONF+x} ]; then
        CERTS_VAR_OUT_CONF="${CERTS_DIR_VAR_NAME_CONF}=\"${CERTS_DIR_CONF}\""
    fi

    if [ -f "ca_cert_conf.pem" ] || [ -f "ca_key_conf.pem" ]; then
        echo "error: You already have \"./ca_cert_conf.pem\" and \"ca_key_conf.pem\" files. \
Delete them first and then run this script again if you want to \
generate new files, for example:"
        echo ""
        printf '%b\n' 'rm ca_cert_conf.pem ca_key_conf.pem; \
'"${BUILD_VAR_OUT_CONF} ${CERTS_VAR_OUT_CONF}"' \
'"${BASH_SOURCE[0]} ${COMMON_NAME_CONF}"
        echo ""
        return 1
    fi

    mkdir -p ${BUILD_DIR_CONF}

    cd ${BUILD_DIR_CONF}

    rm ca_cert_conf.pem ca_key_conf.pem 2>/dev/null || true

    # openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \

    # # The certificate will only be valid for 1,000,000 years.
    # openssl req -new -newkey rsa:4096 -days 365000000 -nodes -x509 \
    #   -subj "/C=CA/ST=Unlisted/L=Unlisted/O=Unlisted/OU=Unlisted/CN=${COMMON_NAME_CONF}" \
    #   -keyout ca_key_conf.pem -out ca_cert_conf.pem

    # chmod 600 ca_cert_conf.pem

    # cp ca_cert_conf.pem ca_key_conf.pem ../

    # mkdir -p ../${CERTS_DIR_CONF}
    # cp ca_cert_conf.pem ../${CERTS_DIR_CONF}

    # TODO: Support other encryption algorithms (maybe requires two separate commands instead of just one):
    # openssl genrsa -aes128 -out server-key.pem

    # Gen cert for config site. The certificate will only be valid for 1,000 years :( due to some restriction from openssl.
    # openssl req -x509 -newkey rsa:4096 -sha256 -days 365000 -nodes \
    openssl req -x509 -newkey rsa:2048 -sha256 -days 365000 -nodes \
      -keyout ca_key_conf.pem -out ca_cert_conf.pem -subj "/C=CA/ST=Unlisted/L=Unlisted/O=Unlisted/OU=Unlisted/CN=${COMMON_NAME_CONF}" \
      -addext "subjectAltName=DNS:${COMMON_NAME_CONF},IP:${COMMON_IP_CONF}"
    
    # openssl req -newkey rsa:4096 -nodes -keyout ca_key_conf.pem -x509 -days 365000000 -out ca_cert_conf.pem -subj "/CN=${COMMON_NAME_CONF}"
    # openssl req -newkey rsa:2048 -nodes -keyout ca_key_conf.pem -x509 -days 365000000 -out ca_cert_conf.pem -subj "/CN=${COMMON_NAME_CONF}"

    chmod 600 ca_cert_conf.pem

    cp ca_cert_conf.pem ca_key_conf.pem ../

    mkdir -p ../${CERTS_DIR_CONF}
    cp ca_cert_conf.pem ca_key_conf.pem ../${CERTS_DIR_CONF}

    cd "$pwd"
}

process_epaper_idf_gen_conf_certs_args "$@"

epaper_idf_gen_conf_certs "$@"
