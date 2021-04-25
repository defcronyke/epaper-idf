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

epaper_idf_flash_firmware_online() {
  GITLAB_USER=${GITLAB_USER:-"defcronyke"}
  GITLAB_REPO=${GITLAB_REPO:-"epaper-idf"}
  GIT_REPO_BRANCH=${GIT_REPO_BRANCH:-"v0.1"}
  SERIAL_PORT=${SERIAL_PORT:-"/dev/ttyUSB0"}
  BAUD_RATE=${BAUD_RATE:-"115200"}
  FLASH_SIZE=${FLASH_SIZE:-"4MB"}

  if [ $# -ge 1 ]; then
    GIT_REPO_BRANCH="$1"
  fi

  if [ $# -ge 2 ]; then
    SERIAL_PORT="$2"
  fi

  if [ $# -ge 3 ]; then
    BAUD_RATE="$3"
  fi

  if [ $# -ge 4 ]; then
    FLASH_SIZE="$4"
  fi

  URL_BASE="https://gitlab.com/$GITLAB_USER/$GITLAB_REPO/builds/artifacts/$GIT_REPO_BRANCH/raw/"; \
  FILENAME="epaper-idf-$GIT_REPO_BRANCH.bin"; \
  PARTITION_FILENAME="epaper-idf-partition-table-$GIT_REPO_BRANCH.bin"; \
  OTA_DATA_FILENAME="epaper-idf-ota-data-initial-$GIT_REPO_BRANCH.bin"; \
  BOOTLOADER_FILENAME="epaper-idf-bootloader-$GIT_REPO_BRANCH.bin"; \
  WWW_FILENAME="epaper-idf-www-$GIT_REPO_BRANCH.bin"; \
  curl -sL ${URL_BASE}partition-table.bin?job=build-job \
  > "$PARTITION_FILENAME" && \
  curl -sL ${URL_BASE}ota_data_initial.bin?job=build-job \
  > "$OTA_DATA_FILENAME" && \
  curl -sL ${URL_BASE}bootloader.bin?job=build-job \
  > "$BOOTLOADER_FILENAME" && \
  curl -sL ${URL_BASE}www.bin?job=build-job \
  > "$WWW_FILENAME" && \
  curl -sL ${URL_BASE}epaper-idf.bin?job=build-job \
  > "$FILENAME" && \
  esptool.py -p "$SERIAL_PORT" -b "$BAUD_RATE" \
  write_flash --flash_size "$FLASH_SIZE" \
  0x1000 "$BOOTLOADER_FILENAME" \
  0x8000 "$PARTITION_FILENAME" \
  0xd000 "$OTA_DATA_FILENAME" \
  0x10000 "$FILENAME" \
  0x30c000 "$WWW_FILENAME"; \
  rm "$PARTITION_FILENAME"; \
  rm "$OTA_DATA_FILENAME"; \
  rm "$BOOTLOADER_FILENAME"; \
  rm "$WWW_FILENAME"; \
  rm "$FILENAME"
}

epaper_idf_flash_firmware_online $@
