#!/bin/sh

pwd="$PWD"

BUILD_DIR=${BUILD_DIR:-"build/"}
CERTS_DIR=${CERTS_DIR:-"server_certs/"}

mkdir -p ${BUILD_DIR}

cd ${BUILD_DIR}

openssl req -x509 -newkey rsa:4096 -keyout ca_key.pem -out ca_cert.pem -days 365000 -nodes

chmod 600 ca_cert.pem

cp ca_cert.pem ca_key.pem ../

mkdir -p ../${CERTS_DIR}
cp ca_cert.pem ../${CERTS_DIR}

cd "$pwd"
