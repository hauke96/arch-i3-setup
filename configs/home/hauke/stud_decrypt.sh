#!/bin/bash

echo "Verfügbare Online-Versionen:"
wget --spider -r --no-parent http://hauke-stieler.de/studium/backups/ 2>&1 | grep -e "gpg$" | awk -F 'hauke-stieler.de/studium/backups/Studium_|.zip.gpg' '{print "> "$2}'

echo
echo "Verfügbare Offline-Versionen:"
ls -1 | grep -e "^Studium_.*\.zip\.gpg$" --color=never | awk -F 'Studium_|.zip.gpg' '{print "> "$2}'

echo
echo "Welche Version möchtest du haben?"
read -p "> " version

# if it already exists from prior updates
if [ ! -e "./Studium_$version.zip.gpg" ]; then
	echo "Downloading file..."
	wget hauke-stieler.de/studium/backups/Studium_$version.zip.gpg
fi

mv ~/Studium ~/Studium_old
gpg -d -r mail@hauke-stieler.de -o Studium.zip Studium_$version.zip.gpg
unzip Studium.zip
