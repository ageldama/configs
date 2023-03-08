#!/bin/sh

zenity --question --text='reboot?' || exit -1

pgrep systemd && systemctl reboot
xterm -e sudo reboot
