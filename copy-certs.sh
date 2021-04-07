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

epaper_idf_copy_certs() {
    BUILD_DIR=${CERT_DIR:-"build/"}
    CERT_DIR=${CERT_DIR:-"certs/"}

    if [ ! -f "ca_cert.pem" ] || [ ! -f "ca_key.pem" ]; then
        echo "error: You haven't created these certificate files yet: ./ca_cert.pem, ca_key.pem"
        echo ""
        echo "Run the following script first to generate the certificates:"
        echo ""
        echo "./gen-certs.sh"
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

    scp *.pem "$@"
    scp *.pem "$@"/$BUILD_DIR
    scp ca_cert.pem "$@"/$CERT_DIR
}

epaper_idf_copy_certs $@
