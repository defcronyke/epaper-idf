#!/bin/sh

pwd="$PWD"

BUILD_DIR=${BUILD_DIR:-"build/"}

mkdir -p ${BUILD_DIR}

cd ${BUILD_DIR}

openssl dhparam -out dhparam.pem 4096
chmod 600 dhparam.pem

cp dhparam.pem ../

cd "$pwd"
