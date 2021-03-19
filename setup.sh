#!/bin/bash

source ./base.sh

# Setup Users
function create_user()
{
	assert_root

	useradd -m hauke
	passwd hauke
	echo "hauke ALL=(ALL) ALL" >> /etc/sudoers
}

# Setup pacman
function setup_pacman()
{
	assert_root
	
	if ! grep -q "^\[multilib\]" /etc/pacman.conf
	then
		echo "Add multilib repo"
		echo "[multilib]" >> /etc/pacman.conf
		echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
	fi

	pacman -Syu	
}

# Creates a group, a user, adds the user to the sudoers file and sets up the AUR
function setup_system()
{
	# 1. Add user and add to sudoers
	create_user

	# 2. Init pacman
	setup_pacman

	# 3. Copy stuff to new users home
	mkdir /home/hauke/setup
	cp -r ./* /home/hauke/setup/
}

# ############################################################################
# 
#  START SETUP
# 
# ############################################################################

setup_system

echo
echo
echo "Next steps:"
echo " 1. Login as 'hauke'"
echo " 2. Go into the 'setup' folder"
echo " 3. Execute the 'install.sh' script"
