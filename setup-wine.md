1. Install Steam + Proton (maybe just proton via AUR works as well)
2. Install `lib32-gnutls lib32-libpulse`
3. Edit `.bashrc`:
```
export W="/home/hauke/.steam/steam/steamapps/common/Proton\ 7\.0/dist"
export WINEVERPATH="$W"
#export PATH=$W/bin:$PATH
export WINESERVER="$W/bin/wineserver"
export WINELOADER="$W/bin/wine"
export WINEDLLPATH="$W/lib/wine/fakedlls"
export LD_LIBRARY_PATH="$W/lib:$LD_LIBRARY_PATH"
export WINEPREFIX=~/.steam/steam/steamapps/compatdata/1887720/pfx
alias wine="$W/bin/wine"
```

I also (because I tried a lot) installed the following packages but they might not be negessary: `wine winetricks wine-mono dxvk-bin`.
I then ran `winetricks corefonts dotnet48`.
