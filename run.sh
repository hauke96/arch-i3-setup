#!/bin/bash


# ############################################################################
# 
#  START SETUP
# 
# ############################################################################

setup_system
echo
echo "System setup done. Continue with desktop installation."
echo
echo

# ############################################################################
# 
#  START INSTALLATION
# 
# ############################################################################

cd /home/hauke/setup
sudo -u $USER ./install.sh
echo "Desktop installation done. Nothing left to do."

echo
echo
echo "We did it :D"
echo "Reboot your system, log into your account, call 'startx' and you are ready to go."
