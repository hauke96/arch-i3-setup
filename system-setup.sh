#!/bin/bash

source ./base.sh

# Setup Users
function create_user()
{
	assert_root

	useradd -m $TARGET_USER
	echo "Added user $TARGET_USER"

	passwd $TARGET_USER

	if ! grep -q "^$TARGET_USER" /etc/sudoers
	then
		chmod 0660 /etc/sudoers
		echo "$TARGET_USER ALL=(ALL) ALL" >> /etc/sudoers
		chmod 04460 /etc/sudoers

		echo "Added $TARGET_USER to sudoers"
	else
		echo "User $TARGET_USER already in sudoers file"
	fi
}

# Generates and sets correct locales
function setup_locale()
{
	if ! grep -q "^$LOC_GEN" /etc/locale.gen
	then
		echo "Activate locale '$LOC_GEN'"
		echo "$LOC_GEN" >> /etc/locale.gen
	else
		echo "Locale already active"
	fi
	locale-gen

	echo 'LANG="'"$LOC"'"' > /etc/locale.conf
	echo 'LC_DATE="'"$LOC"'"' >> /etc/locale.conf
	echo 'LC_NUMERIC="'"$LOC"'"' >> /etc/locale.conf
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
	else
		echo "Multilib already added"
	fi

	pacman -Syu	
}



# 1. Add user and add to sudoers
echo "Create user"
create_user
echo "User creation done"

# 2. Adjust locale
echo "Set up locale"
setup_locale
echo "Locale setup done"

# 3. Init pacman
echo "Set up pacman"
setup_pacman
echo "Pacman setup done"

# 4. Copy stuff to new users home
echo "Copy configs into target users home folder"
mkdir /home/$TARGET_USER/setup
cp -r ./* /home/$TARGET_USER/setup/
chown $TARGET_USER:$TARGET_USER -R /home/$TARGET_USER/setup
echo "Copying configs into target users home folder done"
