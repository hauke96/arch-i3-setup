# For QT style
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_STYLE_OVERRIDE="kvantum"
export XDG_CURRENT_DESKTOP=KDE
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export GTK_THEME=Breeze-Dark

# Set DISPLAY variable in systemd. Needed for e.g. dunst.
systemctl --user import-environment DISPLAY

# Enable numlock
numlockx &

# For globale kde binding. Needed by e.g. spectacle
#exec kglobalaccel5 &

# Start KWalletd
exec kwalletd5 &

# Start akonadi
exec akonadictl start &

exec nitrogen --restore >> ~/.nitrogen.log &

#exec if [ -f ~/.i3.log ]; then mv ~/.i3.log ~/.i3.log.old; fi
exec i3 -V -d all > ~/.i3.log
