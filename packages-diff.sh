#!/bin/bash

# Qe = Installed later (after arch installation)
sudo pacman -Qe | awk '{print $1}' | sort > packages-installed.txt

cat packages/aur/* packages/pacman/* | grep -v "^#\|^\s*$" | sort > packages-setup.txt

echo "Red  : Installed but not in repo."
echo "Green: In repo but not installed."
echo

git --no-pager diff --no-index packages-installed.txt packages-setup.txt
