#!/bin/bash
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --height 17 --transparent true --tint 0x000000 &
dropbox start
nm-applet --sm-disable &
xmonad
