#!/bin/bash

source ./install-util.sh

# ############################################################################
# 
#  SYSTEM SETUP
# 
# ############################################################################

echo "Start system setup"
./install-system.sh
echo
echo "System setup done."
echo
echo

# ############################################################################
# 
#  GRUB THEME
# 
# ############################################################################

echo "Start GRUB theming"
cd grub
./install.sh
cd ..
echo
echo "GRUB theming done."
echo
echo

# ############################################################################
# 
#  INSTALLATION
# 
# ############################################################################

echo "Switch to $TARGET_USER home folder"
cd /home/$TARGET_USER/setup

echo "Start desktop installation script"
sudo -u $TARGET_USER ./install-desktop.sh
echo "Desktop installation done. Nothing left to do."

echo
echo
echo "We did it :D"
echo "Reboot your system, log into your account, call 'startx' and you are ready to go."
