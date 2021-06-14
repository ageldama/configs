#!/usr/bin/env bash

rofi_command="rofi "

xscreensaver="xscreensaver"
redshift="redshift"
sink_default="sink_default"
sink_all="sink_all"
sink_src_all="sink_src_all"

# Error msg
msg() {
	rofi -e "$1"
}

# Variable passed to rofi
options="$xscreensaver\nredshift\nsink_default\nsink_all\nsink_src_all"

chosen="$(echo -e "$options" | $rofi_command -p "Toggle:" -dmenu -selected-row 0)"
case $chosen in
    $xscreensaver)
        xscreensaver-toggle.pl
        ;;
    $redshift)
        kill -USR1 $(pidof redshift)
        ;;
    $sink_default)
        pactl-mute.pl sink toggle_default
        ;;
    $sink_all)
        pactl-mute.pl sink toggle_all
        ;;
    $sink_src_all)
        pactl-mute.pl sink all; pactl-mute.pl source all
        ;;
esac
