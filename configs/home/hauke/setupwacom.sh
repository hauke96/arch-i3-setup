#!/bin/bash

if [ "$1" == "r" ]
then
	xsetwacom --set "Wacom Intuos S Pen stylus" Area -15200 0 15200 9500
elif [ "$1" == "l" ]
then
	xsetwacom --set "Wacom Intuos S Pen stylus" Area 0 0 30400 9500
else
	cat<<END
Unknown parameter: $1

Known parameters:
  r  Enables wacom on the RIGHT monitor
  l  Enables wacom on the LEFT monitor
END
fi
xsetwacom --set "Wacom Intuos S Pen stylus" PressureCurve "50" "50" "100" "80"
xsetwacom --set "Wacom Intuos S Pen stylus" Threshold "50"
