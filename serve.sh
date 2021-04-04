#!/bin/bash

process_epaper_idf_serve_args() {
    epaper_idf_script_args=()

    for arg in "$@"; do
        epaper_idf_script_args+=("${arg}")
    done

    set -- "${epaper_idf_script_args[@]}"

    export EPAPER_IDF_SCRIPT_ARGS=$@
}

epaper_idf_serve() {
    HOST=${1:-"esprog"}
    PORT=${2:-"8089"}
    CERT_DIR=${CERT_DIR:-"build/"}

    go_back() {
        cd "$pwd"
    }

    pwd="$PWD"

    cp ca_cert.pem ca_key.pem dhparam.pem "$CERT_DIR"

    idf.py build

    cd "$CERT_DIR"

    ln -sf "$(basename "$pwd").bin" "firmware.bin"

    trap 'go_back' INT

    echo "The device will request firmware from: https://${HOST}:${PORT}/firmware.bin"

    openssl s_server -cert ca_cert.pem -key ca_key.pem -dhparam dhparam.pem -accept ${PORT} -WWW
}

process_epaper_idf_serve_args "$@"

epaper_idf_serve "$@"
