#!/bin/bash

set -x

echo "Start shutdown: $(date)"

# Exit all applications that might cause inconsistend backups
killall firefox
killall kmail
killall kontact
killall keepassxc
killall telegram-desktop
killall signal-desktop
killall goland
killall webstorm

# Update packages
sudo pacman -Syu

# Stop akonadi as this also might inconsistend backups
akonadictl stop

# Create backups
./backup.sh /media/backup-home /home/hauke
sudo ./backup.sh /media/backup-data/system/current "/etc /var /boot /opt"
./backup.sh /media/backup-data/data /media/data

# Actually shutdown
echo "End shutdown: $(date)"
shutdown -h now
