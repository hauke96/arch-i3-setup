# For QT style
export QT_QPA_PLATFORMTHEME="qt5ct"
export XDG_CURRENT_DESKTOP=KDE

# Set DISPLAY variable in systemd. Needed for e.g. dunst.
systemctl --user import-environment DISPLAY

# For globale kde binding. Needed by e.g. spectacle
exec kglobalaccel5 &

# Start KWalletd
exec kwalletd5 &

# Start akonadi
exec akonadictl start &

exec i3
