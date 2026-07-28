#!/bin/sh

if [ -n "$1" ] && [ "$1" -gt 0 ]; then
    sleep "$1"
fi

map_capslock_as_control() {
    xmodmap -e 'keycode 66 = Control_L'
    xmodmap -e 'clear Lock'
    xmodmap -e 'add Control = Control_L'
}

map_capslock_as_control

while [ -n "$1" ] && [ "$1" -eq -1 ]; do
    if xmodmap -pm|grep -q -E '^control.+0x42'; then
        exit 0
    fi
    echo RETRY
    map_capslock_as_control
    sleep 1
done
