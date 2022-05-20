#!/bin/bash

CACHE="$HOME/.cache/rofi.filecache"

if [ "$@" ]
then
	FILE=$(echo "$1" | sed -E "s/(.*)  \[(.*)\]/\2\1/")
	coproc ( "xdg-open" "$FILE" >/dev/null 2>&1 )
	exit 0
fi

if [ ! -f "$CACHE" ]
then
	./runner.sh
fi

cat "$CACHE"
