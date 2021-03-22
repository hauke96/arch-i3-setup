This is my desktop system setup I use every day.
The key components are:

* i3-gaps
* polybar
* rofi
* konsole
* BreezeDark style with different colors

# Notice

1. This contains configs and files **I** like to use
2. Some of the configs (e.g. the `/etc/fstab` or drivers) only fit to my system. You probably want to change these

# 1. Requirement: Arch

Well ... simply install Arch duh.

And then these things:

* At least 5GB space at `/tmp`

# 2. Installation

This installs everything:

1. Log in as `root`
2. Install `git`
3. `git clone https://github.com/hauke96/arch-i3-setup.git`
4. `cd arch-i3-setup`
5. Optional: Replace "hauke" and locale in the `base.sh`
6. `./run.sh`
7. Follow instructions
8. Optional: Reboot
9. Log into your users account
10. `startx`

# 3. Afterwards

Some more things are needed:

* Setup SSH-Key
* Setup GPG-Keys
* Setup keepass database
* Add mail accounts in `KMail`
* Add firefox profile
* Activate software that needs license key etc.
* ...
