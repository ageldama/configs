#!/bin/sh
xclock -digital -update 1 -twentyfour -render \
       -strftime '%H:%M:%S' -bg '#222222' -fg '#fb7c00' \
       -face 'DSEG7 Classic:style=Bold Italic:size=16' &

PID=$!

sleep 1s

icesh -p $PID borderless bottom right sticky setLayer 12


EOD=<<EOF

sticky
        Show the window on all workspaces.


setLayer
        Window layer
        Named symbols of the domain Window layer (numeric range: 0-15):

Desktop                (0)
Below                  (2)
Normal                 (4)
OnTop                  (6)
Dock                   (8)
AboveDock             (10)
Menu                  (12)
Fullscreen            (14)
AboveAll              (15)

EOF
