# NanoPC T6 homeserver setup scripts


## Hardware used

You'll need the following hardware:
- A NanoPC-T6 (I used the version with metal case)
- An NVMe SSD drive. Not all drives work: Samsung 970 and 990 SSD drivers are known the work. A WD Blue SN570 2TB did not work at all.

Devices similar to the NanoPC-T6 may work with these scripts as well, but have not been tested. I used the NanoPC-T6 since it has 2 ports (can be used as router), a powerful yet energy-efficient processor (RK3588) and an NVMe slot for storage. I picked the 16GB version. 8GB may also be sufficient.

## Other prerequisites

- You need a Windows laptop or PC with a LAN port (or LAN port adapter). You also need a wired LAN connection at your desk.

## Flashing the NanoPC-T6

Preparing to flash:
- Install the USB driver
- Download the usb firmware -> rk3588-usb-friendlywrt-22.03-docker-YYYYMMDD.img.gz 
- Extract the gz to a folder

Flashing:
- Prepare the power adapter
- Push the MASK button with a paperclip
- Insert the power adapter while holding the MASK button
- Wait for 3 seconds
- Release the MASK button
- Connect the NanoPC with your PC (I connected USB-C to USB-C)
- Open the RKDevTool.exe
- Check that it found the device (screenshot!)
- Click the execute button (screenshot!)
- Wait until finished

Connecting to PC:
- Connect ETH1 (WAN port) to a wired connection in your house
- Connect ETH2 (LAN port) to your PC
- Test by going to http://friendlwrt , username "root", pasword "password"

Securing the box:
- Login