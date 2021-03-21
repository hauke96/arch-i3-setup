#!/bin/bash

root=$PWD

while IFS= read -r -d '' dir; 
do 
	if [ -d "$dir/.git" ]
	then
		cd "$dir";
		number="`git log --branches --not --remotes | grep "^commit" | wc -l`";

		if [ "$number" != "0" ]
		then
			echo "$dir [ UNPUSHED: "$number" ]";
		fi

		cd "$root";
	fi
done < <(find -type d -print0)
