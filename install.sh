#!/bin/bash

source ./base.sh

# Setup AUR
function setup_aur()
{
	assert_not_root

	sudo pacman -S --needed git
	
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
	pacman_install "driver-graphics.txt"
}

# Printer driver. Uses KDE's kcm_printer_manager.
function install_driver_printer()
{
	assert_root

	LOG=${0##*/}.log
	PRINT_MANAGER="kcmshell5 kcm_printer_manager"
	
	su hauke -c "yay -S --needed brother-hl5450dn"
	
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
	pacman_install "driver-wacom.txt"
}

# Driver
function install_all_drivers()
{
	assert_root

	install_driver_graphics
	install_driver_printer	
	install_driver_misc
}

# Xorg
function install_i3_xorg()
{
	pacman_install "x.txt"
}

# i3 and required packages to make everything fancy *.*
function install_i3()
{
	install_i3_xorg
	aur_install "i3"
	
	#systemctl enable sddm
	
	# Set locales correctly, because that doesn't work always correctly
	#echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
	#locale-gen
	
	sudo tee -a /etc/locale.conf <<EOF
LC_DATE="de_DE.UTF-8
LC_NUMERIC="de_DE.UTF-8
LC_COLLATE="de_DE.UTF-8
EOF
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
	su hauke -c "yay -S qemu-kvm"

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
	su hauke -c "yay -S --needed signal"

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

	su hauke -c "yay -S --needed spotify"
}

# TODO
function install_theme()
{
	assert_not_root

	mkdir -p ~/.local/share/color-schemes/
	mkdir -p ~/.local/share/plasma/desktoptheme/

	cp kde-breeze-dark-green/BreezeDarkGreen.colors ~/.local/share/color-schemes/BreezeDarkGreen.colors
	cp -r kde-breeze-dark-green/breeze-dark-green ~/.local/share/plasma/desktoptheme/
	cp kde-breeze-dark-green/plasmarc ~/.config/
}

# TODO
function install_configs()
{
	mkdir -p ~/.gnupg
	cp ./gpg-agent.conf ~/.gnupg/
}

# ############################################################################
# 
#  START SETUP AND INSTALLATION
# 
# ############################################################################

setup_aur
install_driver_graphics
install_i3
