#!/bin/bash

# n - native (via pacman)
sudo pacman -Qe | awk '{print $1}' | sort > packages-installed.txt

cat packages/aur/* packages/pacman/* | grep -v "^#\|^\s*$" | sort > packages-setup.txt

git diff --no-index packages-installed.txt packages-setup.txt
