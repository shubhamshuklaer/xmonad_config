#!/bin/bash
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --height 17 --transparent true --tint 0x000000 &
dropbox start
nm-applet --sm-disable &
fluxgui &
memory_low_notify.sh &
yakuake &
# https://github.com/davidbrewer/xmonad-ubuntu-conf
# Run the gnome-keyring-daemon to avoid issues you otherwise may encounter
# when using gnome applications which expect access to the keyring, such
# as Empathy. This prevents prompts you may otherwise get for invalid
# certificates and the like.
gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh
feh --bg-fill ~/wall_paper
# For composting
xcompmgr -c &
xmonad
