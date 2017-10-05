#!/bin/bash
toggle_touchpad () {
    xinput | grep Touchpad| perl -ne '/id=(\d+)/ && print $1' | xargs xinput --"$1"
}

if [[ "$0" =~ "enable" ]]; then
    toggle_touchpad "enable"
elif [[ "$0" =~ "disable" ]]; then
    toggle_touchpad "disable"
else
    echo "Please specify enable/disable in filename." >&2
    exit 1
fi

