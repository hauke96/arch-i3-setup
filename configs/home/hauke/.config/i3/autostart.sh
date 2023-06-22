#!/bin/bash

# Wait one second to ensure that all layout restore windows from i3 are up.
# This is necessary because an already opened application is not catched by a
# layout resore window, which will just stay open.
sleep 1

(telegram-desktop) &
(signal-desktop) &
(spotify) &
(firefox) &
(thunderbird) &
(keepassxc) &
