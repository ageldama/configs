#!/bin/bash


XSCREENSAVER_DIR=/usr/libexec/xscreensaver

declare -a XSCREENSAVERS=()

# xscreensaver-gl
for DPKG in xscreensaver-data xscreensaver-data-extra xscreensaver-screensaver-bsod; do
  S=$(dpkg -L ${DPKG} | grep -E "^${XSCREENSAVER_DIR}/")
  XSCREENSAVERS+=(${S})
done

SELECTED_IDX=$((RANDOM % ${#XSCREENSAVERS[@]}))
SELECTED=${XSCREENSAVERS[$SELECTED_IDX]}

echo "SELECTED: ${SELECTED}"
"${SELECTED}" &
PID=$!
echo "PID: ${PID}"

sleep 0.5s
WID=$(wmctrl -lp | awk "\$3 == ${PID} { print \$1 }")
echo "WID: ${WID}"

wmctrl -i -r "${WID}" -b add,fullscreen

function TRAP_KILL_CHILD () {
  kill "${PID}"
}

trap TRAP_KILL_CHILD EXIT

wait ${PID}

