#!/bin/sh
xmessage "$(fortune -a `find /usr/share/games/fortunes -maxdepth 1  -name '*.dat' -printf '%f\n' | sed s/.dat$//g | shuf -n1`)" \
  -default okay -center \
  -fn 12x24 \
  -bg black -fg '#ffbf00'

