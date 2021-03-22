#!/bin/bash

# Lists all changed configs with their changes.
# Use  --name-only  to only show file names of changed config files.

cd configs
ALL_FILES="$(find . -type f | tr '\n' ' ')"
cd ..

for FILE in $ALL_FILES
do
	DIFF=$(diff $FILE /$FILE)

	if [ -n "$(echo "$DIFF" | tr -d "[:space:]*")" ]
	then
		echo "$FILE"
		if [ "$1" != "--name-only" ]
		then
			echo
			echo "$DIFF"
			echo
			echo
			echo
		fi
	fi
done

