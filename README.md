# epaper-idf - An ESP-IDF firmware project for e-paper displays

[![world soup remastered](https://defcronyke.gitlab.io/epaper-idf/http-slideshow/1.bmp)](https://defcronyke.gitlab.io/epaper-idf/http-slideshow/1.bmp)

[![pipeline status master](https://gitlab.com/defcronyke/epaper-idf/badges/master/pipeline.svg)](https://gitlab.com/defcronyke/epaper-idf/-/pipelines) [![pipeline status v0.1](https://gitlab.com/defcronyke/epaper-idf/badges/v0.1/pipeline.svg)](https://gitlab.com/defcronyke/epaper-idf/-/commits/v0.1) [![sponsor the project](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&link=https://github.com/sponsors/defcronyke)](https://github.com/sponsors/defcronyke)

Copyright (c) 2021 [Jeremy Carter](https://eternalvoid.net) `<`[jeremy@jeremycarter.ca](mailto:Jeremy%20Carter%20<jeremy@jeremycarter.ca>?subject=epaper-idf)`>`

## This is a work in progress

## Project Links

- epaper-idf

  - https://gitlab.com/defcronyke/epaper-idf
  - https://github.com/defcronyke/epaper-idf

- epaper-idf-component

  - https://gitlab.com/defcronyke/epaper-idf-component
  - https://github.com/defcronyke/epaper-idf-component

- Adafruit-GFX-Component

  - https://github.com/defcronyke/Adafruit-GFX-Component

_It's not working properly yet, so please don't try running it on your microcontrollers yet until further notice or else it might break them. Check back later for new developments and updates..._

## Details

- An ESP IDF component for Espressif ESP32 microcontroller-based e-paper display firmware projects.
- Has streamlined support for WiFi HTTPS over-the-air (OTA) firmware updates.
- Aims to solve some of the usability problems that some of the other ESP32 e-paper display libraries have.
- I currently only have one model of e-paper screen to test with: WaveShare 7.5" 640x384 b/w Gdew075T8
- Only ESP32 ESP-IDF (Espressif's official FreeRTOS SDK) support is planned. This will not work for Arduino framework-based projects.

I am making this as an attempt to eventually replace some existing solutions which are floating around online currently (at least replace them for my own usage), since everything I could find had too many outstanding issues, and I didn't like the way their code was organized personally. I'll be happy if anyone else finds this useful, otherwise I'll just use it myself if no-one notices it.

---

## Acknowledgements

- Some of the code in this project is borrowed (and heavily modified/improved) from the OG e-paper library known as: [ZinggJM/GxEPD](https://github.com/ZinggJM/GxEPD)
- Some of the code is loosely inspired by this other ESP IDF component project for e-paper displays: [martinberlin/cale-idf](https://github.com/martinberlin/cale-idf)

A big thanks to the authors of the above projects for releasing theirs with permissive licensing, so I could derive some ideas from their existing work. Both of those projects have too many bugs though, and I wanted to make my own thing instead of trying to convince them to let me patch up their projects (well the first guy flat-out refused my bugfixes actually). Maybe at some point this will be a worthwhile alternative to the above, but until then, check out those projects because they are much more mature than mine.

---

## Quickstart - Install the pre-built firmware

This is how to install an already compiled version of the firmware if you don't intend to modify it. Otherwise, skip this section and follow the instructions in the other sections below if you're going to be modifying the firmware:

1. Install espressif's official esptool.py firmware flashing utility:

   ```shell
   # Install the python-based firmware flashing tool:
   pip install esptool

   # (Optional) If the above command doesn't work, try this one:
   python -m pip install esptool
   ```

2. Flash the latest release version of the epaper-idf firmware:

   ```shell
   bash <(curl -sL https://tinyurl.com/epaper-idf-flash)
   ```

3. (Optional) Flash the latest development version of the epaper-idf firmware instead (the git master branch version):

   ```shell
   bash <(curl -sL https://tinyurl.com/epaper-idf-flash) master
   ```

---

## Full Instructions

### Prerequisites

1. Install the current stable version of Espressif's ESP32 IDF:  
   [https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/index.html](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/index.html)
1. If on ESP32 IDF v4.2, their release is bugged, so you have to do the following additional steps to fix it:

   ```shell
   cd ~/esp/esp-idf && \
   git checkout remotes/origin/release/v4.2 && \
   git submodule update --init --recursive && \
   ./install.sh
   ```

### To clone this project with git

```shell
# Clone the current stable version (well it's not really stable yet though):
git clone -b v0.1 --recursive https://gitlab.com/defcronyke/epaper-idf.git

# (Optional) Or clone the current development version instead:
git clone --recursive https://gitlab.com/defcronyke/epaper-idf.git
```

### To update this project if you already have a copy cloned with git

```shell
# Git commands:
git pull; \
git submodule update --init --recursive

# (Optional) Use the helper bash script instead:
./update-git-repos.sh
```

### To set up the project for OTA firmware updating ability, do this once

```shell
# Generate the DH param (this takes a really long time,
# sometimes dozens of minutes):
./gen-dhparam.sh

# Generate the auth certificates. Change the "esprog" argument below to
# your dev computer's DNS hostname, or leave it as-is and set your network's
# DNS config to recognise your dev computer at the hostname "esprog":
./gen-certs.sh esprog

# Copy the new certificates onto your development machine, wherever you'll
# be hosting the OTA firmware updating procedure from. The below command's
# argument is a valid scp destination path, and the destination should be
# somewhere containing an up-to-date cloned copy of this project's git
# repository:
./copy-certs.sh $USER@dev-machine:~/epaper-idf
```

### To configure the firmware

```shell
# Source the esp-idf each time you open a new terminal instance:
. idf.env

# Open the firmware configuration (Kconfig) menu:
idf.py menuconfig
```

1. Make sure you configure the settings inside the menus named "`[<>] Project ...`".
1. You might want to change the device's "Local netif hostname" (default is "epaper") in the "Component config -> LWIP" menu as well.
1. At a minimum you'll have to select your e-paper device from the menu, otherwise compiling will give an error. You should definitely check the GPIO pin mappings while you're at it, since it's critical that you get those mappings correct if you don't want to break your e-paper display, and the defaults are likely not going to be correct for the way you wired up your devices.

### To build the firmware

```shell
# Specify the firmware short version. If the major or minor version
# changes, it breaks backwards-compatibility by changing the name of
# the EpaperIDF class:
./build.sh v0.1

# (Optional) Specify the firmware version. If the major or minor
# version changes, it breaks backwards-compatibility by changing the
# name of the EpaperIDF class:
./build.sh v0.1.0
```

### To install the firmware onto the ESP32 device

```shell
# Install the firmware you just built onto the device, and begin
# monitoring with a serial console. The firmware will be built first
# if necessary.
# Specify the firmware short version. If the major or minor version
# changes, it breaks backwards-compatibility by changing the name of
# the EpaperIDF class:
./flash.sh v0.1

# (Optional) Specify the firmware version. If the major or minor
# version changes, it breaks backwards-compatibility by changing the
# name of the EpaperIDF class:
./flash.sh v0.1.0
```

### To view the ESP32 device's serial console

```shell
idf.py monitor
```

### OTA firmware updating instructions

1. Configure your LAN's DNS to point the hostname "`esprog`" at the IP address of your firmware dev computer, or change the "`esprog`" argument to your hostname when running the "`./gen-certs.sh esprog`" script, as mentioned in an earlier section.
1. Make sure you put the auth certificates in place on your dev computer first, using the "`./copy-certs.sh`" script as mentioned above. You should have copied them into a folder containing an up-to-date version of this project's git repository. Re-read the earlier instructions if the OTA updates aren't working properly for you.
1. Run the following script on your dev computer to build the new version of your firmware, and then begin hosting it for the device to do an OTA update:

   ```shell
   # Specify the firmware short version. If the major or minor version
   # changes, it breaks backwards-compatibility by changing the name of
   # the EpaperIDF class. To trigger the OTA update, the micro version
   # will be auto-incremented by +1 to the value in the file
   # version-micro.txt:
   ./serve.sh v0.1

   # (Optional) Specify the firmware version. If the major or minor
   # version changes, it breaks backwards-compatibility by changing the
   # name of the EpaperIDF class. If the device is already running this
   # version, it won't do an OTA update during startup:
   ./serve.sh v0.1.0
   ```

1. After the above script is finished building the firmware, it will start waiting for OTA update requests from the device. Reboot your ESP32 device to get it to connect and update itself with the new firmware version (or just wait for the deep sleep wakeup timer to fire if you're using deep sleep).

Whenever you want to load new firmware, run the server script and wait for the firmware to finish building, then reboot the ESP32 device to load the new firmware onto it (or just wait for the deep sleep wakeup timer to fire if you're using deep sleep).
