#!/bin/sh

PLACE=37.566:126.977

NIGHT_COLORTEMP=$(redshift -h | perl -wlne '/Night temperature: (.+)$/i and print $1')

CUR_COLORTEMP=$(redshift -p -l ${PLACE} | perl -wlne '/Color temperature: (.+)$/ and print $1')

echo $NIGHT_COLORTEMP
echo $CUR_COLORTEMP   # FIXME: it's the *DESIRED* color-temp, not the current color-temp of the display.

#redshift -x
#redshift -o -l $PLACE

