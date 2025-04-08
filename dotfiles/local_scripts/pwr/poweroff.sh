#!/bin/sh

zenity --question --text='power-ff?' || exit -1

xterm -e loginctl poweroff
pgrep systemd && systemctl poweroff
xterm -e sudo poweroff
