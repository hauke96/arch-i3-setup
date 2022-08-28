#!/bin/bash

CACHE="$HOME/.cache/rofi.filecache"

# Find all files:
# - in max. 5 folder depth
# - only files, no folder
# - ignore all hidden folders as they contain a lot of uninteresting files
# - ignore certain folders like git repos and node_module
# - Just some formating: <file-name>  [<folder-name>]
find \
	-maxdepth 5 \
	-type f \
	| grep -v "\./\.[^/]*/" \
	| grep -v "\.git/\|/node_modules/" \
	| grep -Pv "\.(toc|snm|nav|out|aux|synctex.gz)$" \
	| sed -E "s/^(.*\/)?(.*)$/\2  [\1]/g" \
	> "$CACHE"
