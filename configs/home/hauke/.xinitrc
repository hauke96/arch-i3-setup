# KDE, QT and GTK styles
#export QT_QPA_PLATFORMTHEME="gtk3"
#export QT_STYLE_OVERRIDE="kvantum"
#export XDG_CURRENT_DESKTOP=KDE
#export GTK_THEME=Breeze-Dark

# XDG configs
#export XDG_DATA_HOME="$HOME/.local/share"
#export XDG_CONFIG_HOME="$HOME/.config"
#export XDG_CACHE_HOME="$HOME/.cache"
set -a # Deactivates the need for "export"
source .config/environment.d/user.conf
set +a

# Set DISPLAY variable in systemd. Needed for e.g. dunst.
systemctl --user import-environment DISPLAY

# Enable numlock
numlockx &

# Desktop background image
exec nitrogen --restore >> ~/.nitrogen.log &

#exec if [ -f ~/.i3.log ]; then mv ~/.i3.log ~/.i3.log.old; fi
#exec i3 -V -d all > ~/.i3.log
exec i3 -V > ~/.i3.log
