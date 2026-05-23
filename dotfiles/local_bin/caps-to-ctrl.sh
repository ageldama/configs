#!/bin/sh

if [ -n "$1" ]; then
    sleep "$1"
fi

xmodmap -e 'keycode 66 = Control_L'
xmodmap -e 'clear Lock'
xmodmap -e 'add Control = Control_L'


