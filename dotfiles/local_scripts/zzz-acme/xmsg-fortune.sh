#!/bin/sh

DIR=/usr/share/games/fortunes
FIND=find
SHUF=shuf
BASENAME=basename
FORTUNE_PREFIX=

# FreeBSD: /usr/local/share/games/fortune
if [ "$(uname)" = "FreeBSD" ]; then
    DIR=/usr/local/share/games/fortune
    FIND=gfind
    SHUF=gshuf
    BASENAME=gbasename
    FORTUNE_PREFIX="${DIR}/"
fi

FORTUNE=$($BASENAME $($FIND $DIR -maxdepth 1 -name '*.dat' -printf '%f\n' | $SHUF | head -n1) .dat)

echo $FORTUNE

xmessage "$(fortune -a ${FORTUNE_PREFIX}${FORTUNE})" \
  -title "fortune: $FORTUNE" \
  -default okay -center \
  -fn 12x24 \
  -bg black -fg '#ffbf00'

# -xrm 'xmessage.title: "Title"'
