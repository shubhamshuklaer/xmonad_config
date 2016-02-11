#!/bin/bash
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --height 17 --transparent true --tint 0x000000 &
dropbox start &
# nm-applet --sm-disable &
# fluxgui &
memory_low_notify.sh &
# yakuake &
tilda &
# https://github.com/davidbrewer/xmonad-ubuntu-conf
# Run the gnome-keyring-daemon to avoid issues you otherwise may encounter
# when using gnome applications which expect access to the keyring, such
# as Empathy. This prevents prompts you may otherwise get for invalid
# certificates and the like.
# gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh &
# for lockeing screen need to be run in order for light-locker-command -l to
# work. dm-tool lock will call this first to lock and then switch to virtual
# terminal 8 and display greeter
light-locker &
# feh --bg-fill ~/wall_paper &
# For composting
# Composting hurts performance
# xcompmgr -c &
# Set cursor
xsetroot -cursor_name left_ptr
# Add to font path
xset fp+ /usr/X11R6/lib/X11/fonts/TTF/
# Set beep off we can also use xset b off
# xset b 100 0 0 means 100% vol 0 pitch and 0 duration
xset b 100 0 0
# Keyboard autorepeat this one is very fast the default autorepeat speed
# is good enough
# xset r rate 200 100
variety &
# Convert vides added in songs folder to mp3 in Music/songs folder
# Script in xmonad folder in dropbox
conv_songs_watch.sh &
# 2 is stderr and 1 is stdout file discreptor
# 2>&1 redirects stderr to stdout
exec xmonad > $HOME/.xmonad/log.txt 2>&1
#dbus-launch --exit-with-session xmonad
