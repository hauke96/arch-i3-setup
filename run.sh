#!/bin/bash

source ./base.sh

# ############################################################################
# 
#  START SETUP
# 
# ############################################################################

echo "Start system setup"
./system-setup.sh
echo
echo "System setup done. Continue with desktop installation."
echo
echo

# ############################################################################
# 
#  START INSTALLATION
# 
# ############################################################################

echo "Switch to $TARGET_USER home folder"
cd /home/$TARGET_USER/setup

echo "Start desktop installation script"
sudo -u $TARGET_USER ./desktop-install.sh
echo "Desktop installation done. Nothing left to do."

echo
echo
echo "We did it :D"
echo "Reboot your system, log into your account, call 'startx' and you are ready to go."
