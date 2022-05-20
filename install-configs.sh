#!/bin/bash

source ./install-util.sh

cd configs
PWD=$(pwd)

#cd home

OIFS="$IFS"
IFS=$'\n'
for f in $(find . -type f)
do
	FILE="$f"
	#TARGET="/home${f#"."}"
	TARGET=${f#"."}
	TARGET_DIR="${TARGET%/*}"
	#SRC="$PWD${f#"."}"
	SRC="$PWD$TARGET"

	if [ ! -d "$TARGET_DIR" ]
	then
		echo "Create target dir $TARGET_DIR"
		sudo mkdir -p "$TARGET_DIR"
	fi

	echo "Remove existing file $TARGET"
	sudo rm -f "$TARGET"

	echo "Create symlink $TARGET -> $SRC"
	sudo ln -s "$SRC" "$TARGET"

	# Set owner on files of user
	if [[ "$TARGET" == "/home/$TARGET_USER"* ]]
	then
		echo "Set ownership of $TARGET to $TARGET_USER"
		sudo chown -h $TARGET_USER:$TARGET_USER "$TARGET"
	fi
done
IFS="$OIFS"

cd ..

echo "Installed configs"
