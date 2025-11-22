#!/usr/bin/env bash


XSCREENSAVER_DIR=/usr/libexec/xscreensaver
XSCREENSAVER_DEMO_PID=/tmp/xscreensaver-demo-rand.${UID}.pid

declare -a XSCREENSAVERS=()

# STOP: xscreensaver-gl
DPKGS="xscreensaver-data xscreensaver-data-extra xscreensaver-screensaver-bsod"
mapfile -t XSCREENSAVERS < <(
    echo "${DPKGS[@]}" \
        | xargs dpkg -L \
        | grep -E "^${XSCREENSAVER_DIR}/" \
        | grep -v xscreensaver-auth \
        | grep -v xscreensaver-getimage \
        | grep -v xscreensaver-gfx \
        | grep -v xscreensaver-gl-visual \
        | grep -v xscreensaver-systemd \
        | grep -v xscreensaver-text \
        )
# echo "${XSCREENSAVERS[@]}"

SELECTED_IDX=$((RANDOM % ${#XSCREENSAVERS[@]}))
SELECTED=${XSCREENSAVERS[$SELECTED_IDX]}

echo "SELECTED: [${SELECTED}]"
"${SELECTED}" &
PID=$!
echo "PID: ${PID}"
echo "${PID}" > "${XSCREENSAVER_DEMO_PID}"

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

