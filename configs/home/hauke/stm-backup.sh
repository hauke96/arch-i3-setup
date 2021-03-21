#!/bin/bash

set -e

remote_backups="/home/stm/simple-task-manager/backups"
local_backups="/media/externe/Backup/simple-task-manager/"
port=17642

function hline {
	echo
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	echo " $1"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	echo
}

hline "Check external drive"
if mount | grep /dev/sdc1 > /dev/null
then
	echo "External drive already mounted"
else
	echo "External drive not mounted"
	./mount.sh
fi

hline "Get latest backup"
file=$(ssh -p $port stm@stm.hauke-stieler.de "cd $remote_backups && ls -1 ./* | tail -1")
echo "Latest backup is:  $file"

hline "Download backups"
scp -P 17642 -r stm@stm.hauke-stieler.de:$remote_backups/* $local_backups

hline "Remove backups"
ssh -t -p $port stm@stm.hauke-stieler.de "cd $remote_backups && sudo mv $file $file.tmp && sudo rm *.sql.gz && sudo mv $file.tmp $file"

echo
echo
echo "Done."
