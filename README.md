# epaper-idf - e-paper display with esp32 idf

[![sponsor the project](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&link=https://github.com/sponsors/defcronyke)](https://github.com/sponsors/defcronyke)

Copyright (c) 2021 [Jeremy Carter](https://eternalvoid.net) `<`[jeremy@jeremycarter.ca](mailto:Jeremy%20Carter%20<jeremy@jeremycarter.ca>?subject=epaper-idf)`>`

## This is a work in progress

_Check back later for updates..._

## Details

- An ESP IDF component for e-paper display firmware projects.
- Has streamlined support for WiFi HTTPS over-the-air (OTA) firmware updates.
- Aims to solve some of the usability problems that some of the other ESP32 e-paper display libraries have.
- I currently only have one model of e-paper screen to test with: WaveShare 7.5" 640x384 b/w Gdew075T8
- Only ESP32 support is planned, and this code will only work for ESP IDF projects, not with Arduino projects.
- I am making this as an attempt to replace some existing solutions which are floating around online currently (at least replace them for my own usage), since everything I could find had too many outstanding issues, and I didn't like the way their code was organized personally. I'll be happy if anyone else finds this useful, but I'm content to just use it myself if no-one notices it.

---

## Acknowledgements

- Some of the code in this project is borrowed (and heavily modified/improved) from the OG e-paper library known as: [ZinggJM/GxEPD](https://github.com/ZinggJM/GxEPD)
- Some of the code is loosely inspired by this other ESP IDF component project for e-paper displays: [martinberlin/cale-idf](https://github.com/martinberlin/cale-idf)
- A big thanks to the authors of the above projects for releasing theirs with permissive licensing, so I could derive some ideas from their existing work. They both have too many bugs though, and I wanted to make my own thing instead of trying to convince those folks to let me patch up their projects (well the first guy flat-out refused my bugfixes actually). Maybe at some point this one will be a worthwhile alternative to the above, but until then, check out those projects because they are much more mature than mine, even though they are still very buggy.

---

## Quickstart - Install the pre-built firmware

This is how to install an already compiled version of the firmware if you don't intend to modify it. Otherwise, skip this section and follow the instructions in the other sections below if you're going to be modifying the firmware:

1. Install espressif's official esptool.py firmware flashing utility:

   ```shell
   python -m pip install esptool
   ```

1. Flash the latest release version of the epaper-idf firmware:

   ```shell
   FIRMWARE_VERSION="v0.1"; \
   SERIAL_PORT="/dev/ttyUSB0"; \
   BAUD_RATE="115200"; \
   FILENAME="epaper-idf-$FIRMWARE_VERSION.bin"; \
   BOOTLOADER_FILENAME="epaper-idf-bootloader-$FIRMWARE_VERSION.bin"; \
   curl -sL https://gitlab.com/defcronyke/epaper-idf/builds/artifacts/$FIRMWARE_VERSION/raw/bootloader.bin?job=build-job \
   > "$BOOTLOADER_FILENAME" && \
   curl -sL https://gitlab.com/defcronyke/epaper-idf/builds/artifacts/$FIRMWARE_VERSION/raw/epaper-idf.bin?job=build-job \
   > "$FILENAME" && \
   esptool.py -p "$SERIAL_PORT" -b "$BAUD_RATE" write_flash 0x00000 "$BOOTLOADER_FILENAME" && \
   esptool.py -p "$SERIAL_PORT" -b "$BAUD_RATE" write_flash 0x10000 "$FILENAME"; \
   rm "$BOOTLOADER_FILENAME"; \
   rm "$FILENAME"
   ```

1. (Optional) Flash the latest development version of the epaper-idf firmware instead (the git master branch version):

   ```shell
   FIRMWARE_VERSION="master"; \
   SERIAL_PORT="/dev/ttyUSB0"; \
   BAUD_RATE="115200"; \
   FILENAME="epaper-idf-$FIRMWARE_VERSION.bin"; \
   BOOTLOADER_FILENAME="epaper-idf-bootloader-$FIRMWARE_VERSION.bin"; \
   curl -sL https://gitlab.com/defcronyke/epaper-idf/builds/artifacts/$FIRMWARE_VERSION/raw/bootloader.bin?job=build-job \
   > "$BOOTLOADER_FILENAME" && \
   curl -sL https://gitlab.com/defcronyke/epaper-idf/builds/artifacts/$FIRMWARE_VERSION/raw/epaper-idf.bin?job=build-job \
   > "$FILENAME" && \
   esptool.py -p "$SERIAL_PORT" -b "$BAUD_RATE" write_flash 0x00000 "$BOOTLOADER_FILENAME" && \
   esptool.py -p "$SERIAL_PORT" -b "$BAUD_RATE" write_flash 0x10000 "$FILENAME"; \
   rm "$BOOTLOADER_FILENAME"; \
   rm "$FILENAME"
   ```

---

## Prerequisites

1. Install the current stable version of Espressif's ESP32 IDF:  
   [https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/index.html](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/index.html)
2. If on ESP32 IDF v4.2, their release is bugged, so you have to do the following additional steps to fix it:

   ```shell
   cd ~/esp/esp-idf && \
   git checkout remotes/origin/release/v4.2 && \
   git submodule update --init --recursive && \
   ./install.sh
   ```

## To clone this project with git

```shell
# Clone the current stable version (well it's not really stable yet though):
git clone -b v0.1 --recursive https://gitlab.com/defcronyke/epaper-idf.git

# Or clone the current development version instead:
git clone --recursive https://gitlab.com/defcronyke/epaper-idf.git
```

## To update this project if you already have a copy cloned with git

```shell
git pull; \
git submodule update --init --recursive
```

## To set up the project for OTA firmware updating ability, do this once

```shell
# generate the DH param
./gen-dhparam.sh

# when asked, set the Common Name (CN) as: esprog
./gen-cert.sh
```

## To configure the firmware

```shell
# source the esp-idf each time you open a new terminal instance
. idf.env

# open the firmware configuration (Kconfig) menu
idf.py menuconfig
```

1. Make sure you configure the items inside the menus named "Project ...".
2. You might want to change the device's "Local netif hostname" (default is "epaper") in the "Component config -> LWIP" menu.
3. At a minimum you'll have to select your e-paper device from the menu, otherwise compiling will give an error. You should definitely check the GPIO pin mappings while you're at it, since it's critical that you get those mappings correct if you don't want to break your e-paper display, and the defaults are likely not going to be correct for the way you wired up your devices.

## To build the firmware

```shell
idf.py build
```

## To install the firmware onto the esp32 device

```shell
idf.py flash
```

## To view the esp32 device's serial console

```shell
idf.py monitor
```

## OTA firmware updating instructions

1. Configure your LAN's DNS to point the hostname "esprog" at the IP address of your firmware dev computer.
2. Make sure you have these files on your dev computer (the same exact ones which were uploaded originally to the esp32 device by non-OTA method): ca_cert.pem, ca_key.pem, dhparam.pem
3. Also copy this file into another spot, like so:

   ```shell
   mkdir -p server_certs && \
   cp ca_cert.pem server_certs/
   ```

4. Update the "Project version" value in the "Application manager" section of the Kconfig menu. This will trigger the ESP32 device to download your new firmware the next time you reboot it if the value is set to something different than what's currently running on the device.
5. Run the following script (make sure your "ca_cert.pem", "ca_key.pem", and "dhparam.pem" files are in the same folder as the script first):

   ```shell
   ./serve.sh
   ```

6. While the above script is running, reboot your esp32 device to load the new firmware (or just wait for the deep sleep wakeup timer to fire if you're using deep sleep).
7. Whenever you want to load new firmware, just change the "Project version" value in the "Application manager" section of the Kconfig menu (higher or lower, it doesn't matter), then run the server script, and reboot the ESP32 device to load the new firmware onto it (or just wait for the deep sleep wakeup timer to fire if you're using deep sleep).
