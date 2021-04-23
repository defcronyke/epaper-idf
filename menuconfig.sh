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

epaper_idf_menuconfig() {
  if [ -z ${IDF_PYTHON_ENV_PATH+x} ]; then
    echo ""
    echo "note: ESP-IDF has not been sourced yet. To speed things up, you can source it first by running the following command:"
    echo ""
    echo ". idf.env"
    echo ""
    echo "note: Sourcing ESP-IDF for you now..."
    echo ""
    . idf.env
  fi

  idf.py menuconfig
}

epaper_idf_menuconfig $@
