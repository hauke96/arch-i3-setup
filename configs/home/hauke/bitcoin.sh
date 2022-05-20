#!/bin/bash

set -e

#cd ~/Apps
#sudo mount /dev/disk/by-uuid/03ea5b37-c934-411b-9785-be55f5f90509 /media/bitcoin
#sudo ./bitcoin-bin/bin/bitcoin-qt
sudo mount /dev/sdf1 /mnt
sudo bitcoin-qt
sudo umount /mnt
