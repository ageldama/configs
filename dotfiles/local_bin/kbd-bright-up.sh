#!/bin/sh
notify-send "$(brightnessctl --device=smc::kbd_backlight s +5%)"

