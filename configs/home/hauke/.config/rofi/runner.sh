#!/bin/bash

CACHE="$HOME/.cache/rofi.filecache"

# Find all files:
# - in max. 7 folder depth
# - only files, no folder
# - ignore all hidden things (they often contain a lot of uninteresting files)
# - ignore certain folders like git repos and node_module
# - Just some formating: <file-name>  [<folder-name>]
find $HOME \
	-maxdepth 5 \
	-type f \
	-follow \
	| grep -v "/\.[^/]*/" \
	| grep -Pv "/(Android/Sdk|bin|cache|CMakeFiles|fdroiddata|go/pkg|GoPro|lustre|okular|node_modules|obj|out|tmp|zfs)/" \
	| grep -Pv "/xyz(-(raster-tiles|vector-tiles))?/" \
	| grep -Pv "\.(a|aux|bbl|blg|dvi|log|map|nav|o|out|pygtex|rom|snm|sty|synctex.gz|toc|tmp|vrb)$" \
	| sed -E "s/^(.*\/)?(.*)$/\2  [\1]/g" \
	> "$CACHE"
# Not necessary because all hidden stuff is ignored: | grep -Pv "\.(android|cache|git|idea|metadata|run|tmp)" \
