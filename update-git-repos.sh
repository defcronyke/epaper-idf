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

git pull; git submodule update --init --recursive

# Update 3rd-party Javascript dependencies for the web app portion:
cd components/epaper-idf-component/web && \
npm i && \
cd ../../..
