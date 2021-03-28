# epaper-idf  
  
## e-paper display with esp32 idf  
  
Copyright (c) 2021 [Jeremy Carter](https://eternalvoid.net) `<`[jeremy@jeremycarter.ca](mailto:Jeremy%20Carter%20<jeremy@jeremycarter.ca>?subject=epaper-idf)`>`  
  
----------  
  
### Prerequisites  
  
1. Install the current stable version of Espressif's ESP32 IDF:  
   [https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/index.html](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/index.html)  
2. If on ESP32 IDF v4.2, their release is bugged, so you have to do the following additional steps to fix it:

   ```shell
   cd ~/esp/esp-idf && \
   git checkout remotes/origin/release/v4.2 && \
   git submodule update --init --recursive && \
   ./install.sh
   ```

### To set up the project for OTA firware updating ability, do this once  
  
```shell
# generate the DH param
./gen-dhparam.sh

# when asked, set the Common Name (CN) as: esprog
./gen-cert.sh
```  
  
### To configure the firmware  
  
```shell
# source the esp-idf
. idf.env

# open the firmware configuration menu
idf.py menuconfig
```  

1. Make sure you configure the items inside the menus named "Project ...".
2. You might want to change the device's "Local netif hostname" (default is "epaper") in the "Component config -> LWIP" menu.

### To build the firmware

```shell
idf.py build
```

### To install the firmware onto the esp32 device

```shell
idf.py flash
```

### To view the esp32 device's serial console

```shell
idf.py monitor
```

### OTA firmware updating instructions

1. Configure your LAN's DNS to point the hostname "esprog" at the IP address of your firmware dev computer.
2. Make sure you have these files on your dev computer (the same exact ones which were uploaded originally to the esp32 device by non-OTA method): ca_cert.pem, ca_key.pem, dhparam.pem
3. Also copy this file into another spot, like so:

   ```shell
   mkdir -p server_certs && \
   cp ca_cert.pem server_certs/
   ```

4. Update the version number in the "version.txt file".
5. Build your new firmware, as per the above "To build the firmware" instructions.
6. Run the following script:

   ```shell
   ./serve.sh
   ```

7. While the above script is running, reboot your esp32 device to load the new firmware.
