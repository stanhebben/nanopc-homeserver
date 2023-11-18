# NanoPC T6 homeserver setup scripts


## Hardware used

You'll need the following hardware:
- A NanoPC-T6 (I used the version with metal case)
- An NVMe SSD drive. Not all drives work: Samsung 970 and 990 SSD drives are known to work. A WD Blue SN570 2TB did not work at all.
- An USB-C cable. The NanoPC-T6 has a Type C port that is also used when flashing, so make sure you are able to connect it to your PC.

Devices similar to the NanoPC-T6 may work with these scripts as well, but have not been tested. I used the NanoPC-T6 since it has 2 ports (can be used as router), a powerful yet energy-efficient processor (RK3588) and an NVMe slot for storage. I picked the 16GB version. 8GB may also be sufficient.

This setup assumes that the device will be used as a router, using a device as a separate server on an internal network requires a completely different setup.

## Other prerequisites

- You need a Windows laptop or PC with a LAN port (or LAN port adapter). You also need a wired LAN connection at your desk.
- You'll need Putty installed
- A BackBlaze account, for the backups.

## Flashing the NanoPC-T6

See [the FriendlyElec wiki](http://wiki.friendlyelec.com/wiki/index.php/NanoPC-T6) for details

Download the necessary software from [the FriendlyElec Google Drive folder](https://drive.google.com/drive/folders/1FoBbP_nPkMehwBj4wHwsbRU-QGjEdeEP):
- 01_Official images/03_USB upgrade images/rk3588-usb-friendlywrt-23.05-docker-20231031.zip (or a newer version, but make sure it's the version with docker included)
- 05_Tools/DriverAssitant_v5.1.1.zip

Setup these tools:
- Extract the driver assistant and run DriverInstall.exe
- Extract the image zip file

Flashing:
- Prepare the power adapter
- Push the MASK button with a paperclip
- Insert the power adapter while holding the MASK button
- Wait for 3 seconds
- Release the MASK button
- Connect the NanoPC with your PC (I connected USB-C to USB-C)
- Open the RKDevTool.exe bundled with the official image
- Check that it found the device: it should show "发现一个MASKROM设备" (see screenshot below). If no device was discovered, it will show "没有发现设备" instead and you'll have to try again.
- Click the 执行 ("execute") button (see screenshot below)
- Wait until finished
- You can now disconnect the USB cable

![RKDevTool - found device](screenshots/rkdevtool-1.png)

Connecting to PC:
- Connect ETH1 (WAN port) to a wired connection in your house
- Connect ETH2 (LAN port) to your PC
- Test by going to http://friendlwrt , username "root", pasword "password"

Setup the device:
- Open Putty and connect to "friendlywrt", username `root` password `password`
- Check out the setup repository on it:

```
git clone https://github.com/stanhebben/nanopc-homeserver.git
cd nanopc-homeserver
```

- If the SSD in your device has never been formatted before, run `bash 1-format-ssd.sh` which will setup the partition table an ext4 partition on it
- Run `bash 2-setup.sh`
- Enter your new root password
- Login to your BackBlaze acount
- Go to Application Keys (under the Account section in the left navigation)
- Add a new application key
- Give it a name and press "Create new Key"
- The key ID and key will appear in a blue box
- Go back to your Putty SSH session
- Copy and paste (right click to paste) the Key ID of the newly generated key and press enter
- Copy and paste the key and press enter
- Perform some checks to see if everything works correctly so far:
	- Browse to http://friendlywrt:8000 with your browser - username is root and password is the one you just chose. It should show the configuration page.
	- Run `lsblk` to check that your SSD is correctly mounted - it should show an `nvme0n1p1` partition mounted to `/mnt/ssd`
- Reboot the device: `reboot`
- Login to the device again and go back to the nanopc-homeserver directory
- Start setup of runtipi: `bash 3-runtipi.sh`
