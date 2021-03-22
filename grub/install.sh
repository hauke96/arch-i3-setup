#!/bin/bash

echo "Install Grub theme"

echo "First mount EFI partition /dev/sda1 to /boot"
mount /dev/sda1 /boot

THEME_DIR="/boot/grub/themes"
THEME_NAME=Xenlism-Arch

# Create themes directory if not exists
echo "Make sure the theme folder exists"
[[ -d ${THEME_DIR}/${THEME_NAME} ]] && rm -rf ${THEME_DIR}/${THEME_NAME}
mkdir -p "${THEME_DIR}/${THEME_NAME}"

# Copy theme
echo "Copy theme files"
cp -a ${THEME_NAME}/* ${THEME_DIR}/${THEME_NAME}

# Set theme
# Backup grub config
echo "Backup default grub file"
cp -an /etc/default/grub /etc/default/grub.bak

echo "Add GRUB_THEME entry to default grub file"
grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_THEME=/d' /etc/default/grub

echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub

# Update grub config
echo "Regenerate grub config"
grub-mkconfig -o /boot/grub/grub.cfg
