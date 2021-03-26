#!/bin/bash

# Generates two lists with installed packages from pacman and the AUR.

# n - native (via pacman)
sudo pacman -Qne | awk '{print $1}' | sort > packages.txt
# m - foreign packages not in sync database (installed via yay)
sudo pacman -Qme | awk '{print $1}' | grep -v yay | sort > packages-aur.txt
