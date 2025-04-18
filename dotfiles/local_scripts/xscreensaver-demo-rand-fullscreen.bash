#!/bin/bash


XSCREENSAVER_DIR=/usr/libexec/xscreensaver

declare -a XSCREENSAVERS=()

# xscreensaver-gl
for DPKG in xscreensaver-data xscreensaver-data-extra xscreensaver-screensaver-bsod; do
    mapfile -t S < <(dpkg -L ${DPKG} | grep -E "^${XSCREENSAVER_DIR}/")
    # echo "LEN: ${#S[@]}"
    XSCREENSAVERS+=( "${S[@]}" )
done
# echo "XSCREENSAVERS: ${#XSCREENSAVERS[@]}"

# FIXME:
# xscreensaver-auth
# xscreensaver-getimage
# xscreensaver-getimage-file
# xscreensaver-getimage-video
# xscreensaver-gfx
# xscreensaver-gl-visual
# xscreensaver-systemd
# xscreensaver-text




SELECTED_IDX=$((RANDOM % ${#XSCREENSAVERS[@]}))
SELECTED=${XSCREENSAVERS[$SELECTED_IDX]}

echo "SELECTED: [${SELECTED}]"
"${SELECTED}" &
PID=$!
echo "PID: ${PID}"

while true; do
    WID=$(wmctrl -lp | awk "\$3 == ${PID} { print \$1 }")
    if [[ "${WID}" -ne "" ]]; then
        echo "WID: ${WID}"

        if wmctrl -i -r "${WID}" -b add,fullscreen; then
            break
        fi
    fi

    sleep 0.1s
done

function TRAP_KILL_CHILD () {
  kill "${PID}"
}

trap TRAP_KILL_CHILD EXIT

wait ${PID}

