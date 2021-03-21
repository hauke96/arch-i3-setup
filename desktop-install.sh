#!/bin/bash

source ./base.sh

# Setup AUR
function setup_aur()
{
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
	assert_root

#	LOG=${0##*/}.log
#	PRINT_MANAGER="kcmshell5 kcm_printer_manager"
	
	# Just to make sure driver package is installed which is usually installed via packages/aur/utils.txt
	su $TARGET_USER -c "yay --noconfirm -S --needed brother-hl5450dn"
	
	systemctl enable cups-browsed.service
	systemctl start cups-browsed.service
	
#	echo "Hinweis:"
#	echo "Drucker muss noch eingerichtet werden! Wie folgt vorgehen:"
#	echo 
#	echo "==="
#	echo "1. Drucker-URL finden (z.B. 'lpd://BRN30055C8ADAEE/BINARY_P1'):"
#	echo "==="
#	lpinfo -v
#	echo
#	echo "==="
#	echo "2. Gleich öffnet sich die Verwaltung, da dann einen neuen Drucker hinzufügen"
#	echo "==="
#	echo "3. Für den Drucker die 'driverless' Variante wählen und URL eintragen (die von Schritt 1)"
#	echo "==="
#	echo "4. Treiber auswählen"
#	echo "==="
#	echo "5. Fertig, ggf. Testseite drucken"
#	echo "==="
#	echo
#	echo "Weiter mit zu '$PRINT_MANAGER' ENTER..."
#	read
#	$PRINT_MANAGER
}

# i3 and required packages to make everything fancy *.*
function install_i3()
{
	pacman_install "x"
	sudo localectl --no-convert set-x11-keymap de

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
install_configs
