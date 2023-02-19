#!/bin/bash

set -e

echo "Install Grub theme"

# Check if boot partition mounted
if ! grep -q "^/dev/sda1 " /proc/mounts
then
	echo "Mount EFI partition /dev/sda1 to /boot"
	mount /dev/sda1 /boot
else
	echo "EFI partition already mounted."
fi

THEME_DIR="/boot/grub/themes"
THEME_NAME=Xenlism-Arch

# If folder exists -> remove it to re-install the theme
if [[ -d ${THEME_DIR}/${THEME_NAME} ]]
then
	echo "GRUB theme already installed -> clean up"
	rm -rf "${THEME_DIR}/${THEME_NAME}"
fi

# Create themes directory if not exists
echo "Make sure the theme folder exists"
mkdir -p "${THEME_DIR}/${THEME_NAME}"

# Copy theme
echo "Copy theme files"
cp -a ${THEME_NAME}/* ${THEME_DIR}/${THEME_NAME} || true

# Set theme
# Backup grub config
echo "Backup default grub file"
cp -an /etc/default/grub /etc/default/grub.bak

echo "Remove old GRUB_THEME entry to default grub file"
grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_THEME=/d' /etc/default/grub
echo "Remove old GRUB_GFXMODE entry to default grub file"
grep "GRUB_GFXMODE=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_GFXMODE=/d' /etc/default/grub

echo "Add GRUB_THEME entry to default grub file"
echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub
echo "Add GRUB_GFXMODE entry to default grub file"
echo "GRUB_GFXMODE=\"1920x1080x32\"" >> /etc/default/grub

# Update grub config
echo "Regenerate grub config"
grub-mkconfig -o /boot/grub/grub.cfg
