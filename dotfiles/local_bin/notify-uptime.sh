#!/bin/sh
MSG="$(uname -a)<br>$(uptime)<br>$(date)"
notify-send -u normal uptime "${MSG}"

