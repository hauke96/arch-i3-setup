#!/bin/bash

set -x
	
if [ "$(id -u)" != 0 ]
then
	echo "This must be run as root!"
	exit 1
fi

echo "Start shutdown: $(date)"

# Exit all applications that might cause inconsistend backups
killall firefox
killall kmail
killall kontact
killall thunderbird
killall keepassxc
killall telegram-desktop
killall signal-desktop
killall goland
killall webstorm
killall spotify

# Update packages
#sudo -u hauke yay -Syyu --aur --noconfirm
sudo -u hauke yay -Syyu --sudoloop --noconfirm

# Stop akonadi as this also might inconsistend backups
akonadictl stop

# Create backups
./backup.sh /media/backup-home /home/hauke
./backup.sh /media/backup-data/system/current "/etc /var /boot /opt"
./backup.sh /media/backup-data/data /media/data

# Actually shutdown
echo "End shutdown: $(date)"
sudo shutdown -h now
