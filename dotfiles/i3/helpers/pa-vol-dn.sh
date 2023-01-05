#!/bin/sh
pactl set-sink-volume @DEFAULT_SINK@ -5%
notify-send "$(pa-get-vol.sh)"

