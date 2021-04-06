#!/bin/bash

epaper_idf_flash_firmware_online() {
  FIRM_VER="master"
  SERIAL_PORT="/dev/ttyUSB0"
  BAUD_RATE="115200"
  FLASH_SIZE="4MB"

  if [ $# -ge 1 ]; then
    FIRM_VER="$1"
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

  URL_BASE="https://gitlab.com/defcronyke/epaper-idf/builds/artifacts/$FIRM_VER/raw/"; \
  FILENAME="epaper-idf-$FIRM_VER.bin"; \
  PARTITION_FILENAME="epaper-idf-partition-table-$FIRM_VER.bin"; \
  OTA_DATA_FILENAME="epaper-idf-ota-data-initial-$FIRM_VER.bin"; \
  BOOTLOADER_FILENAME="epaper-idf-bootloader-$FIRM_VER.bin"; \
  curl -sL ${URL_BASE}partition-table.bin?job=build-job \
  > "$PARTITION_FILENAME" && \
  curl -sL ${URL_BASE}ota_data_initial.bin?job=build-job \
  > "$OTA_DATA_FILENAME" && \
  curl -sL ${URL_BASE}bootloader.bin?job=build-job \
  > "$BOOTLOADER_FILENAME" && \
  curl -sL ${URL_BASE}epaper-idf.bin?job=build-job \
  > "$FILENAME" && \
  esptool.py -p "$SERIAL_PORT" -b "$BAUD_RATE" \
  write_flash --flash_size "$FLASH_SIZE" \
  0x8000 "$PARTITION_FILENAME" \
  0xd000 "$OTA_DATA_FILENAME" \
  0x1000 "$BOOTLOADER_FILENAME" \
  0x10000 "$FILENAME"; \
  rm "$PARTITION_FILENAME"; \
  rm "$OTA_DATA_FILENAME"; \
  rm "$BOOTLOADER_FILENAME"; \
  rm "$FILENAME"
}

epaper_idf_flash_firmware_online $@
