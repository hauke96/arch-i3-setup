This is my desktop system setup I use every day.
The key components are:

* i3-gaps
* polybar
* rofi
* konsole
* BreezeDark style with different colors

# Notice

1. This contains configs and files **I** like to use.
2. Some of the configs (e.g. the `/etc/fstab` or drivers) only fit to my system. You probably want to change these.

# 1. Prerequisites

1. Well ... simply install Arch duh.
2. Make sure `/tmp` has at least 5GB space → `mount -o remount,size=5G /tmp/`

# 2. Installation

This installs everything:

1. Log in as `root`
2. Install `git`
3. `git clone https://github.com/hauke96/arch-i3-setup.git`
4. `cd arch-i3-setup`
5. Optional: Replace "hauke" and locale in the `install-util.sh`
6. Start main installation: `./install.sh`
7. Follow instructions
8. Recommended: Reboot
9. Log into your users account
10. `startx`

# 3. Afterwards

Some more things are needed to have a fully working system with all necessary data, profiles, etc.

* Adjust `nautilus`
* Test audio
* Check printer IP in `/etc/cups/printers.conf`
* Setup SSH-Key
* Setup GPG-Keys
* Setup keepass database
* Add mail accounts in `KMail`
* Add firefox profile
* Activate software that needs license key etc.
* ...

# Scripts

This repo contains some scripts:

| Script name | Description |
|:--|:--|
| `generate-package-lists.sh` | Generates lists of all currently installed packages. |
| `find-changed-configs.sh` | Determines all config files that differ from the ones in `./configs/`. Use `--name-only` to just print the file names. |
| `packages-diff.sh` | Show a diff view of all installed packages and all packages registered in this repo under `./packages/`. |
| `install.sh` | Used to start the whole installation process |
| `install-util.sh` | Not a standalone script. Contains important functions and variables. |
| `install-system.sh` | Used internally to set up the system with pacman, AUR, locale, etc. |
| `install-desktop.sh` | Used internally to install all the desktop enviroment things (i3, fonts, browser, IDEs, ...) |

Only use the first three scripts, all others (`install-...`) are internal scripts.

# Development

The `install-...` scripts structure the tasks of the installation process: Installing the system, grub and the desktop + user applications.

In the `./packages/` folder, you'll find different `.txt` files with all packages that should be installed in the last step (which is `install-desktop.sh`).

## Add a package

Just add a new line in an *existing* file.

## Add package file

Adding a new package file requires two steps:

1. Add the file with its package names in it.
2. Add an entry in the `install-desktop.sh' file similar to the existing ones.


