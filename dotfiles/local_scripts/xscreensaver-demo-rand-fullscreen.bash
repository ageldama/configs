#!/bin/bash


XSCREENSAVER_DIR=/usr/libexec/xscreensaver


XSCREENSAVERS=(/usr/libexec/xscreensaver/abstractile
/usr/libexec/xscreensaver/binaryhorizon
/usr/libexec/xscreensaver/binaryring
/usr/libexec/xscreensaver/cwaves
/usr/libexec/xscreensaver/deco
/usr/libexec/xscreensaver/distort
/usr/libexec/xscreensaver/droste
/usr/libexec/xscreensaver/fiberlamp
/usr/libexec/xscreensaver/fuzzyflakes
/usr/libexec/xscreensaver/galaxy
/usr/libexec/xscreensaver/hexadrop
/usr/libexec/xscreensaver/m6502
/usr/libexec/xscreensaver/marbling
/usr/libexec/xscreensaver/metaballs
/usr/libexec/xscreensaver/penrose
/usr/libexec/xscreensaver/popsquares
/usr/libexec/xscreensaver/ripples
/usr/libexec/xscreensaver/scooter
/usr/libexec/xscreensaver/shadebobs
/usr/libexec/xscreensaver/slidescreen
/usr/libexec/xscreensaver/swirl
/usr/libexec/xscreensaver/tessellimage
/usr/libexec/xscreensaver/xlyapr)

SELECTED_IDX=$[$RANDOM % ${#XSCREENSAVERS[@]}]
SELECTED=${XSCREENSAVERS[$SELECTED_IDX]}

echo "${SELECTED}"
"${SELECTED}" &
PID=$!
echo $PID

sleep 0.5s
WID=$(wmctrl -lp | awk "\$3 == $PID { print \$1 }")
echo $WID

wmctrl -i -r $WID -b add,fullscreen

trap "kill $PID" EXIT

wait $PID

