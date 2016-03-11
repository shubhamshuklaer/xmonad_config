#!/bin/bash
# echo $(date) Start >> ~/xmonad_bottle_neck_log
# trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --height 17 --transparent true --tint 0x000000 &
# --SetPartialStrut false lets it float instead of pushing other windows down
# Without trasnpartent true there is no color so we are using transparent with alpha 0
trayer --edge top --align right --SetDockType true --SetPartialStrut false --expand true --width 5 --height 17 --transparent true --alpha 0 --tint 0x000000 &
# echo $(date) trayer started >> ~/xmonad_bottle_neck_log
dropbox start &
# echo $(date) dropbox started >> ~/xmonad_bottle_neck_log
# nm-applet --sm-disable &
# fluxgui &
memory_low_notify.sh &
# echo $(date) memory_low_notify started >> ~/xmonad_bottle_neck_log
# yakuake &
tilda &
# echo $(date) tilda started >> ~/xmonad_bottle_neck_log
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
# echo $(date) light-locker started >> ~/xmonad_bottle_neck_log
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

# echo $(date) xset done >> ~/xmonad_bottle_neck_log
variety &
# echo $(date) variety started >> ~/xmonad_bottle_neck_log
# Convert vides added in songs folder to mp3 in Music/songs folder
# Script in xmonad folder in dropbox
conv_songs_watch.sh &
# echo $(date) conv_songs_watch started >> ~/xmonad_bottle_neck_log
# 2 is stderr and 1 is stdout file discreptor
# 2>&1 redirects stderr to stdout
exec xmonad > $HOME/.xmonad/log.txt 2>&1
#dbus-launch --exit-with-session xmonad
