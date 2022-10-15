#!/bin/sh
pgrep systemd && systemctl poweroff
xterm -e sudo poweroff
