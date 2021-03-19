#!/bin/bash

set -e
#set -o xtrace

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
	sudo pacman -S --needed $(cat ./packages/pacman/$1 | tr '\n' ' ')
}

# Takes a file as parameter and installs all packages in that file
function aur_install()
{
	assert_not_root

	yay -S --needed $(cat ./packages/aur/$1 | tr '\n' ' ')
}

