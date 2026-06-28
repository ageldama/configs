#!/bin/sh

if [ -f ~/.use-asmctl ]; then
  notify-send "$(asmctl key up)"
else
  notify-send "$(brightnessctl --device=smc::kbd_backlight s +5%)"
fi

