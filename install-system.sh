#!/bin/bash

source ./install-util.sh

# Setup Users
function create_user()
{
	assert_root

	useradd -m $TARGET_USER
	echo "Added user $TARGET_USER"

	passwd $TARGET_USER

	# We need sudo already here to add the user to the sudoers file
	echo "Install sudo"
	pacman --noconfirm -S --needed sudo
	echo "Installing sudo done"

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

	# To not type dead keys (like ^ ´ `) twice
	localectl set-x11-keymap de "pc105" nodeadkeys
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

	pacman --noconfirm -Sy	
}



# 1. Setup NTP
sudo systemctl enable ntpdate.service
sudo systemctl start ntpdate.service

# 2. Add user and add to sudoers
echo "Create user"
create_user
echo "User creation done"

# 3. Adjust locale
echo "Set up locale"
setup_locale
echo "Locale setup done"

# 4. Init pacman
echo "Set up pacman"
setup_pacman
echo "Pacman setup done"

# 5. Copy stuff to new users home
echo "Copy configs into target users home folder"
mkdir /home/$TARGET_USER/setup
cp -r ./* /home/$TARGET_USER/setup/
chown $TARGET_USER:$TARGET_USER -R /home/$TARGET_USER/setup
echo "Copying configs into target users home folder done"
