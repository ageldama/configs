#!/bin/sh

if [ -f ~/.use-asmctl ]; then
  asmctl video down
else
  notify-send "$(brightnessctl s 5%-)"
fi


