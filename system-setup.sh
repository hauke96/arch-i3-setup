#!/bin/bash

source ./base.sh

# Setup Users
function create_user()
{
	assert_root

	useradd -m $USER
	echo "Added user $USER"

	passwd $USER

	if ! grep -q "^$USER" /etc/sudoers
	then
		chmod 0660 /etc/sudoers
		echo "$USER ALL=(ALL) ALL" >> /etc/sudoers
		chmod 04460 /etc/sudoers

		echo "Added $USER to sudoers"
	else
		echo "User $USER already in sudoers file"
	fi
}

# Generates and sets correct locales
function setup_locale()
{
	locale-gen
	if ! grep -q "^de_DE.UTF-8 UTF-8" /etc/locale.gen
	then
		echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
	fi

	echo 'LANG="de_DE.UTF-8"' > /etc/locale.conf
	echo 'LC_DATE="de_DE.UTF-8"' >> /etc/locale.conf
	echo 'LC_NUMERIC="de_DE.UTF-8"' >> /etc/locale.conf
	echo 'LC_COLLATE=C' >> /etc/locale.conf
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



# 1. Add user and add to sudoers
create_user

# 2. Adjust locale
setup_locale

# 3. Init pacman
setup_pacman

# 4. Copy stuff to new users home
mkdir /home/$USER/setup
cp -r ./* /home/$USER/setup/
chown $USER:$USER -R /home/$USER/setup
