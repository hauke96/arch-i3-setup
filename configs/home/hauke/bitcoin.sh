#!/bin/bash

set -e

if [[ "$EUID" = 0 ]]
then
	#cd ~/Apps

	echo "Mounting disk"
	mount /dev/disk/by-uuid/a4e8c16e-25c4-416c-93b7-9309262c98de /mnt
	#sudo mount /dev/sdf1 /mnt

	echo "Starting bitcoin client"
	#sudo ./bitcoin-bin/bin/bitcoin-qt
	bitcoin-qt

	echo "Unmounting disk"
	umount /mnt
else
	>&2 echo "Permission denied: This script needs root permissions."
	exit 1
fi
