#!/bin/sh

if [ -f ~/.use-asmctl ]; then
  notify-send "$(asmctl video up)"
else
  notify-send "$(brightnessctl s +5%)"
fi

