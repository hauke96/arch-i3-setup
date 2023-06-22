#!/bin/bash

# Lists all changed configs with their changes.
# Use  --name-only  to only show file names of changed config files.

cd configs
ALL_FILES="$(find . -type f | sed "s/^\.\///g" | tr '\n' ' ')"
cd ..

for FILE in $ALL_FILES
do
	DIFF=$(diff configs/$FILE /$FILE 2>/dev/null)

	if [ -n "$(echo "$DIFF" | tr -d "[:space:]*")" ]
	then
		echo "$FILE"
		if [ "$1" != "--name-only" ]
		then
			echo
			git diff --no-index configs/$FILE /$FILE
			echo
			echo
			echo
		fi
	fi
done

