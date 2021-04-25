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

epaper_idf_copy_conf_certs() {
    BUILD_DIR_CONF=${BUILD_DIR_CONF:-"build/"}
    CERT_DIR_CONF=${CERT_DIR_CONF:-"certs/"}

    if [ ! -f "ca_cert_conf.pem" ] || [ ! -f "ca_key_conf.pem" ]; then
        echo "error: You haven't created these certificate files yet: ./ca_cert_conf.pem, ca_key_conf.pem"
        echo ""
        echo "Run the following script first to generate the certificates:"
        echo ""
        echo "./gen-conf-certs.sh"
        echo ""
        return 1
    fi

    if [ ! -f "dhparam.pem" ]; then
        echo "error: You haven't created the dhparam file yet: ./dhparam.pem"
        echo ""
        echo "Run the following script first to generate the file (it might take a long time):"
        echo ""
        echo "./gen-dhparam.sh"
        echo ""
        return 2
    fi

    scp ca_cert_conf.pem "$@"
    scp ca_key_conf.pem "$@"
    scp dhparam.pem "$@"
    scp ca_cert_conf.pem "$@"/$BUILD_DIR_CONF
    scp ca_key_conf.pem "$@"/$BUILD_DIR_CONF
    scp dhparam.pem "$@"/$BUILD_DIR_CONF
    scp ca_cert_conf.pem "$@"/$CERT_DIR_CONF
    scp ca_key_conf.pem "$@"/$CERT_DIR_CONF
}

epaper_idf_copy_conf_certs $@
