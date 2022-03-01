#!/bin/bash

cp $1 parameterized-$1

declare -A re

# The reverse-map of ./kvantum-svg-parameterize.sh:
re[#000000]=__BLACK
re[#222222]=__DARKEST_GRAY
re[#303030]=__DARK_GRAY
re[#4a4a4a]=__MID_GRAY
re[#808080]=__LIGHT_GRAY
re[#979797]=__LIGHTEST_GRAY
re[#dddddd]=__WHITE
re[#aa9616]=__PRIMARY
re[#aa9b46]=__PALE_PRIMARY
re[#5a4e0c]=__DARK_PRIMARY

re[#000000]=__BLACK
#re[#000]=__BLACK
re[#006edc]=__PRIMARY
re[#0582ff]=__PRIMARY
re[#101010]=__DARKEST_GRAY
re[#1270a2]=__PALE_PRIMARY
re[#1376ab]=__PALE_PRIMARY
re[#147cb4]=__PALE_PRIMARY
re[#148acc]=__PRIMARY
re[#1688c6]=__PRIMARY
re[#1689c6]=__PRIMARY
re[#1e1e1e]=__DARKEST_GRAY
re[#233a5d]=__DARK_PRIMARY
re[#253d61]=__DARK_PRIMARY
re[#282828]=__DARKEST_GRAY
re[#29436b]=__DARK_PRIMARY
re[#2b2b2b]=__DARKEST_GRAY
re[#2d2d2d]=__DARKEST_GRAY
re[#2e2e2e]=__DARKEST_GRAY
re[#2e4c7a]=__DARK_PRIMARY
re[#345588]=__DARK_PRIMARY
re[#35588d]=__DARK_PRIMARY
re[#373737]=__DARK_GRAY
re[#395e97]=__DARK_PRIMARY
re[#3d3d3e]=__DARK_GRAY
re[#3daee9]=__PRIMARY
re[#3e67a6]=__PALE_PRIMARY
re[#3f67a5]=__PALE_PRIMARY
re[#464646]=__DARK_GRAY
re[#4b4b4b]=__DARK_GRAY
re[#505050]=__DARK_GRAY
re[#517bbb]=__PALE_PRIMARY
re[#555555]=__MID_GRAY
#re[#555]=__MID_GRAY
re[#5a5a5a]=__MID_GRAY
re[#5abff4]=__PALE_PRIMARY
re[#5f5f5f]=__MID_GRAY
re[#5f86c1]=__PALE_PRIMARY
re[#636363]=__MID_GRAY
re[#646464]=__MID_GRAY
re[#666666]=__MID_GRAY
#re[#666]=__MID_GRAY
re[#6e6e6e]=__MID_GRAY
re[#707070]=__MID_GRAY
re[#717171]=__MID_GRAY
re[#737373]=__MID_GRAY
re[#787878]=__MID_GRAY
re[#7b7b7b]=__MID_GRAY
re[#7d7d7d]=__LIGHT_GRAY
re[#828282]=__LIGHT_GRAY
re[#969696]=__LIGHT_GRAY
re[#a5a5a5]=__LIGHT_GRAY
re[#aaaaaa]=__LIGHT_GRAY
#re[#aaa]=__LIGHT_GRAY
re[#b74aff]=__HIGHLIGHT
re[#c8c8c8]=__LIGHTEST_GRAY
re[#d2d2d2]=__LIGHTEST_GRAY
re[#e6e6e6]=__LIGHTEST_GRAY
re[#f0f0f0]=__WHITE
re[#ffffff]=__WHITE
#re[#fff]=__WHITE

for c in "${!re[@]}"
do
	sed -i 's/'"$c"'/'"${re[$c]}"'/g' parameterized-$1
done
