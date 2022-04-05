#!/bin/bash

OIFS="$IFS"
IFS=$'\n'
for f in $(find $1 -type f)
do
	FILE=${f#"$1"}
	HASH1=$(cat "$1/$FILE" | sha1sum)
	HASH2=$(cat "$2/$FILE" | sha1sum)
	if [[ "$HASH1" != "$HASH2" ]]
	then
		echo "* $HASH1  |  $HASH2  -  $FILE"
	fi
done
