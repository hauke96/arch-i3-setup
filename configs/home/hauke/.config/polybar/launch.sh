#!/bin/bash

# To make sure the window and desktop system had time to come up.
sleep 2

if type "xrandr"; then
	MONITORS=$(xrandr --query | grep " connected" | cut -d" " -f1)
	for m in $MONITORS; do
		echo "Start polybar for monitor: $m"
		MONITOR=$m polybar --reload -c ~/.config/polybar/config bar &
	done
else
	echo "Start polybar on single monitor"
	polybar --reload -c ~/.config/polybar/config bar &
fi
