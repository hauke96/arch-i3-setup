#!/bin/bash

BACK="$(pwd)"

# $1 - Folder to analyse
# $2 - Index of search
function findFiles()
{
	cd "$1"
	find . -type f | sort > /tmp/foldiff-$2
	#find . -type f -exec sha256sum {} \; | sort > /tmp/foldiff-$2
	
	cd "$BACK"
}

findFiles "$1" 1
findFiles "$2" 2

git diff --no-index /tmp/foldiff-1 /tmp/foldiff-2
if [ $? -eq 0 ]
then
	echo "Folders are equal."
fi
