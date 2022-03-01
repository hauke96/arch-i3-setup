#!/bin/bash

cp $1 "colorized-$1"

declare -A re

re[__BLACK]=#000000
re[__DARKEST_GRAY]=#222222
re[__DARK_GRAY]=#303030
re[__MID_GRAY]=#4a4a4a
re[__LIGHT_GRAY]=#808080
re[__LIGHTEST_GRAY]=#979797
re[__WHITE]=#dddddd
re[__PRIMARY]=#aa9616
re[__PALE_PRIMARY]=#aa9b46
re[__DARK_PRIMARY]=#5a4e0c
re[__HIGHLIGHT]=#8946aa

for c in "${!re[@]}"
do
	sed -i 's/'"$c"'/'"${re[$c]}"'/g' "colorized-$1"
done
