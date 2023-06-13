#!/bin/bash

# Setup script to install our required software and 
# configure services etc.

# Make sure script is run as root.
if [ "$(id -u)" != "0" ]; then
  echo "Must be run as root with sudo! Try: sudo ./setup.sh"
  exit 1
fi

# update and upgrade existing packages
echo "Upgrading existing packages"
echo "=========================="
apt update && apt dist-upgrade -y && apt autoremove -y

# install our required packages
echo "Installing dependencies..."
echo "=========================="
apt-get install git wget vlc util-linux python3 python3-gpiozero python3-pip exfat-fuse exfat-utils -y

# copy our bash script
echo "Install our piVidLooper script..."
echo "=========================="
mkdir /piVidLooperVLC
cd /piVidLooperVLC
wget -N https://raw.githubusercontent.com/jonwitts/pi_vid_looper_VLC/main/piVidLooperVLC.sh
chmod +x ./piVidLooperVLC.sh

# copy our shutdown Python script
echo "Install our Python shutdown script..."
echo "=========================="
wget -N https://raw.githubusercontent.com/jonwitts/pi_vid_looper_VLC/main/pythonShutdown.py
chmod +x ./pythonShutdown.py

# copy and activate our systemd definitions
echo "Copy and activate our systemd definitions..."
echo "=========================="
# piVidLooperVLC service
wget -N https://raw.githubusercontent.com/jonwitts/pi_vid_looper_VLC/main/piVidLooperVLC.service
mv ./piVidLooper.service /lib/systemd/system/piVidLooperVLC.service
chmod 644 /lib/systemd/system/piVidLooperVLC.service

# pythonShutdown service
wget -N https://raw.githubusercontent.com/jonwitts/pi_vid_looper_VLC/main/pythonShutdown.service
mv ./pythonShutdown.service /lib/systemd/system/pythonShutdown.service
chmod 644 /lib/systemd/system/pythonShutdown.service

# reload and enable
systemctl daemon-reload
systemctl enable piVidLooperVLC.service
systemctl enable pythonShutdown.service

# Install and configure the Pimoroni Fan Shim
#cd /
#git clone https://github.com/pimoroni/fanshim-python
#cd fanshim-python
#./install.sh
#cd examples
#sudo ./install-service.sh --on-threshold 65 --off-threshold 55 --delay 2

# up our GPU RAM
#echo "gpu_mem=512" >> /boot/config.txt

# done
echo "Done. Rebooting now"
echo "=========================="
reboot
