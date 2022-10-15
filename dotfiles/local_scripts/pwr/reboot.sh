#!/bin/sh
pgrep systemd && systemctl reboot
xterm -e sudo reboot
