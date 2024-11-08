#!/bin/bash

# trap ctrl-c and call ctrl_c()
trap abort INT

function abort() {
	echo "ABORT"
	exit 1
}

function head {
	echo
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	echo " $1"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	echo
}

function killApp()
{
	echo "Exit $1"
	killall $1
}

# Check if root permissions. If not, nothing of the below will work.
if [ "$(id -u)" != 0 ]
then
	echo "This must be run as root!"
	abort
fi

echo "Start upd at $(date)"

# Exit all applications that might cause inconsistend backups
head "Exit desktop applications"
killall firefox
killall thunderbird
killall keepassxc
killall telegram-desktop
killall signal-desktop
killall goland
killall webstorm
killall spotify
echo "Done closing applications"

# Update packages
head "Update packages"
if ! sudo -u hauke yay -Syyu --noconfirm --sudoloop
then
	abort
fi
echo "Done updating packages"

#head "Update packages (official)"
#pacman -Syyu --noconfirm
#echo "Done updating official packages with pacman"

# Create backups

# This file contains the necessary credentials for the cloud backups
source .backuprc

head "Backup 1/3 (local) - /home/hauke"
./backup.sh /media/backup-home /home/hauke 7 8 12 10
head "Backup 1/3 (cloud) - /home/hauke"
./backup.sh ssh://u431537-sub1@u431537.your-storagebox.de:23/./backups/home-hauke /home/hauke 1 4 12 10 "$BACKUP_HOME_PASSPHRASE"

head "Backup 2/3 (local) - /etc /var /boot /opt"
./backup.sh /media/backup-data/system/current "/etc /var /boot /opt" 7 8 12 10
head "Backup 2/3 (cloud) - /etc /var /boot /opt"
./backup.sh ssh://u431537-sub1@u431537.your-storagebox.de:23/./backups/system "/etc /var /boot /opt" 1 4 12 10 "$BACKUP_SYSTEM_PASSPHRASE"

head "Backup 3/3 (local) - /media/data"
./backup.sh /media/backup-data/data /media/data 7 8 12 10
head "Backup 3/3 (cloud) - /media/data"
./backup.sh ssh://u431537-sub1@u431537.your-storagebox.de:23/./backups/data /media/data 1 4 12 10 "$BACKUP_DATA_PASSPHRASE"

echo "Finished all backups"

# Actually shutdown
head "Actual shutdown"
echo "End upd at $(date)"
shutdown -h now
