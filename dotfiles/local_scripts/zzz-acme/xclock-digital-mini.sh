#!/bin/sh
xclock -digital -update 1 -twentyfour -render \
       -strftime '%H:%M:%S' -bg '#222222' -fg '#fb7c00' \
       -face 'DSEG7 Classic:style=Bold Italic:size=16' &

PID=$!

sleep 1s

icesh -p $PID borderless move 0 0


