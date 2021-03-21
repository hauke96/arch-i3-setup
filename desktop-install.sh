#!/bin/bash

source ./base.sh

# Setup AUR
function setup_aur()
{
	assert_not_root

	sudo pacman -S --needed git base-devel
	
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
function install_driver_printer()
{
	assert_root

	LOG=${0##*/}.log
	PRINT_MANAGER="kcmshell5 kcm_printer_manager"
	
	su $TARGET_USER -c "yay -S --needed brother-hl5450dn"
	
	systemctl enable cups-browsed.service
	systemctl start cups-browsed.service
	
	echo "Hinweis:"
	echo "Drucker muss noch eingerichtet werden! Wie folgt vorgehen:"
	echo 
	echo "==="
	echo "1. Drucker-URL finden (z.B. 'lpd://BRN30055C8ADAEE/BINARY_P1'):"
	echo "==="
	lpinfo -v
	echo
	echo "==="
	echo "2. Gleich öffnet sich die Verwaltung, da dann einen neuen Drucker hinzufügen"
	echo "==="
	echo "3. Für den Drucker die 'driverless' Variante wählen und URL eintragen (die von Schritt 1)"
	echo "==="
	echo "4. Treiber auswählen"
	echo "==="
	echo "5. Fertig, ggf. Testseite drucken"
	echo "==="
	echo
	echo "Weiter mit zu '$PRINT_MANAGER' ENTER..."
	read
	$PRINT_MANAGER
}

function install_driver_misc()
{
	assert_root
	pacman_install "driver-wacom"
}

# Driver
function install_all_drivers()
{
	assert_root

	install_driver_graphics
	install_driver_printer	
	install_driver_misc
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

# TODO
function install_apps()
{
	assert_root

	# System
	pacman -S --needed \
		htop \
		baobab \
		mtr \
		openssh \
		gnu-netcat \
		gnome-calculator \
		ufw \
		zip
	
	# Development
	pacman -S --needed \
		git \
		tk \
		go \
		openjdk8-src \
		jdk8-openjdk \
		hugo \
		eclipse-java \
		liteide \
		atom \
		hunspell-de \
		hunspell-en_US \
		virt-manager \
		qemu \
		ovmf \
		texlive-core \
		texlive-bibtexextra \
		texlive-fontsextra \
		texlive-langextra \
		texlive-latexextra \
		texlive-science \
		texstudio
	yay -S --needed latex-pgfplots
	su $TARGET_USER -c "yay -S qemu-kvm"

	# Internet
	pacman -S --needed \
		openvpn \
		firefox \
		thunderbird \
		telegram-desktop \
		hexchat \
		rsync \
		wget \
		keepassxc \
		xdotool \
		filezilla \
		ktorrent \
		kdeconnect \
		sshfs
	su $TARGET_USER -c "yay -S --needed signal"

	# Gaming
	pacman -S --needed \
		steam \
		lib32-libxtst \
		lib32-libxrandr \
		lib32-glib2 \
		lib32-libpulse \
		lib32-gtk2 \
		lib32-libva \
		lib32-libvdpau \
		lib32-openal

	# Multimedia
	pacman -S --needed \
		vlc \
		gimp \
		darktable \
		gwenview \
		okular \
		imagemagick \
		ffmpeg \
		pavucontrol \
		skanlite

	su $TARGET_USER -c "yay -S --needed spotify"
}

# TODO
function install_gpg_configs()
{
	mkdir -p ~/.gnupg
	cp ./gpg-agent.conf ~/.gnupg/
}

# 1. Setup AUR
setup_aur

# 2. Install important packages
install_driver_graphics

# 3. Install basic desktop packages and utilities
install_i3
pacman_install "fonts"
pacman_install "utils"

# 4. Install normal applications
# TODO

# 5. Copy all configs
install_configs
