#!/bin/bash

set -e
#set -o xtrace

# Inportant and often used values:
TARGET_USER="hauke"
LOC="de_DE.UTF-8"
LOG_GEN="$LOC UTF-8"

# Assert that user is root
function assert_root()
{
	if [ "$(id -u)" != 0 ]
	then
		echo "This must be run as root!"
		exit 1
	fi
}

# Assert that user is NOT root
function assert_not_root()
{
	if [ "$(id -u)" == 0 ]
	then
		echo "This must NOT be run as root!"
		exit 1
	fi
}

# Takes a file as parameter and installs all packages in that file
function pacman_install()
{
	echo "Start pacman installation of $1"
	sudo pacman -S --needed $(cat ./packages/pacman/$1.txt | grep -v "^#" | tr '\n' ' ')
	echo "Installed $1"
}

# Takes a file as parameter and installs all packages in that file
function aur_install()
{
	assert_not_root

	echo "Start AUR installation of $1"
	yay -S --needed $(cat ./packages/aur/$1.txt | grep -v "^#" | tr '\n' ' ')
	echo "Installed $1"
}

