#!/bin/sh

zenity --question --text='power-ff?' || exit -1

pgrep systemd && systemctl poweroff
xterm -e sudo poweroff
