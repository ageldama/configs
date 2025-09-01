#!/bin/sh

FORTUNE=$(basename $(find /usr/share/games/fortunes -maxdepth 1 -name '*.dat' -printf '%f\n' | shuf -n1) .dat)

xmessage "$(fortune -a $FORTUNE)



*** from: $FORTUNE ***" \
  -default okay -center \
  -fn 12x24 \
  -bg black -fg '#ffbf00'

