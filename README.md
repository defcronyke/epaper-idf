# epaper-idf  
  
## e-paper display with esp32 idf  
  
Copyright (c) [Jeremy Carter](https://eternalvoid.net) `<`[jeremy@jeremycarter.ca](mailto:Jeremy Carter <jeremy@jeremycarter.ca>)`>`  
  
----------  
  
### Prerequisites  
  
* Install the current stable version of Espressif's ESP32 IDF:  
  [https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/index.html](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/index.html)  
  
### To set up the project for OTA, do this once  
  
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

### OTA firmware updating

1. Configure your LAN's DNS to point the hostname "esprog" at the IP address of your firmware dev computer.
2. Update the version number in the "version.txt file".
3. Build your new firmware, as per the above "To build the firmware" instructions.
4. Run the following script:

   ```shell
   ./serve.sh
   ```

5. While the above script is running, reboot your esp32 device to load the new firmware.
