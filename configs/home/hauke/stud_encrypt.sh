#!/bin/bash

set -e

DATE=$(date +%Y-%m-%d)
NAME_ZIP='Studium_'$DATE'.zip'

echo "Start compressing..."
zip -qr -9 $NAME_ZIP Studium

echo "Start encrypting ..."
gpg -e -r mail@hauke-stieler.de $NAME_ZIP

echo "Remove ZIP file ..."
rm $NAME_ZIP

echo -e "\nFile created: "$NAME_ZIP".gpg"
