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

epaper_idf_serve_web_min_exit() {
  cd "$1"
}

epaper_idf_serve_web_min() {
  pwd="$PWD"

  trap "epaper_idf_serve_web_min_exit $pwd" INT

  cd components/epaper-idf-component

  ./serve-web-min.sh

  cd "$pwd"
}

epaper_idf_serve_web_min $@
