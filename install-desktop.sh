#!/bin/bash

source ./install-util.sh

# Setup AUR
function setup_aur()
{
	if command -v yay > /dev/null
	then
		echo "AUR already set up"
		return
	fi

	assert_not_root

	sudo pacman --noconfirm -S --needed git base-devel
	
	export BUILDDIR=/tmp/makepkg
	export PKGDEST=.
	export SRCDEST=.
	
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -sci
	
	cd ..
	rm -rf yay
}

# Graphics driver
function install_driver_graphics()
{
	pacman_install "driver-graphics"
}

# Printer driver. Uses KDE's kcm_printer_manager.
function setup_printer()
{
	# Just to make sure driver package is installed which is usually installed via packages/aur/utils.txt
	yay --noconfirm -S --needed brother-hl5450dn

	sudo systemctl enable cups-browsed.service

	# Necessary config files will be copied later. Therefore the cups-browsed service will not be started here.
}

# i3 and required packages to make everything fancy *.*
function install_i3()
{
	pacman_install "x"
	aur_install "i3"
}

# Copy all the config files
function install_configs()
{
	cd configs
	sudo cp -r --parents ./* /
	sudo chown $TARGET_USER:$TARGET_USER -R /home/$TARGET_USER
	cd ..

	echo "Installed configs"
}

# 1. Setup AUR
setup_aur

# 2. Install important packages
install_driver_graphics
pacman_install "driver-graphics"
pacman_install "driver-wacom"
pacman_install "driver-filesystem"

# 3. Install basic desktop packages and utilities
install_i3
pacman_install "fonts"
pacman_install "utils"

# 4. Install normal applications
pacman_install "normal"
pacman_install "development"
aur_install "normal"
aur_install "development"
aur_install "utils"

# 5. Set up printer
setup_printer

# 6. Copy all configs

# 6.1 Copy all files and overwrite existing ones
install_configs

# 6.2 Copy fstab without overriding existing configs
cat ./fstab >> /etc/fstab

# 7. Clean up things

# 7.1 Set java version so that JetBrains IDEs start
sudo archlinux-java set java-11-openjdk

# 7.2 Start CUPS after configs have been copied
sudo systemctl start cups-browsed.service
