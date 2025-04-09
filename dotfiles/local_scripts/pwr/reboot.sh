#!/bin/sh

yesno.pl 'reboot?' || exit -1

xterm -e loginctl reboot
pgrep systemd && systemctl reboot
xterm -e sudo reboot
