#!/bin/bash

HOST=${1:-"esprog"}
PORT=${2:-"8089"}
CERT_DIR=${CERT_DIR:-"build/"}

go_back() {
    cd "$pwd"
}

pwd="$PWD"

cd "$CERT_DIR"

ln -sf "$(basename "$pwd").bin" "firmware.bin"
ln -sf ../version.txt

cp ../ca_cert.pem ../ca_key.pem ../dhparam.pem .

trap 'go_back' INT

echo "The device will request firmware from: https://${HOST}:${PORT}/firmware.bin"

openssl s_server -cert ca_cert.pem -key ca_key.pem -dhparam dhparam.pem -accept ${PORT} -WWW
