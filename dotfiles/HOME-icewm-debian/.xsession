#!/bin/sh
export PATH=$PATH:$HOME/local/bin

xrdb -load ~/.Xresources

killall icewmbg &
(sleep 1s; xsetroot -solid '#333333') &

~/local/bin/caps-to-ctrl.sh &

ssh-add < /dev/null &

SEOUL_POS=37.566:126.977 # Seoul
redshift-gtk -l $SEOUL_POS &


xscreensaver &

dunst &

exec icewm


