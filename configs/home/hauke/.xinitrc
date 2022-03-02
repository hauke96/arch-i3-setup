# For QT style
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_STYLE_OVERRIDE="kvantum"
export XDG_CURRENT_DESKTOP=KDE

# Set DISPLAY variable in systemd. Needed for e.g. dunst.
systemctl --user import-environment DISPLAY

# Enable numlock
numlockx &

# For globale kde binding. Needed by e.g. spectacle
exec kglobalaccel5 &

# Start KWalletd
exec kwalletd5 &

# Start akonadi
exec akonadictl start &

exec i3
