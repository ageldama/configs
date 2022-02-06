#!/usr/bin/env bash

rofi_command="rofi "

xscreensaver="xscreensaver"
redshift="redshift"
sink_default="sink_default"
sink_all="sink_all"
sink_src_all="sink_src_all"
poweroff="poweroff"
reboot="reboot"

# Error msg
msg() {
	rofi -e "$1"
}

# Variable passed to rofi
options="$xscreensaver\nredshift\nsink_default\nsink_all\nsink_src_all\n------\npoweroff\nreboot"

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
    $poweroff)
        pgrep systemd && systemctl poweroff
        xterm -e sudo poweroff
        ;;
    $reboot)
        pgrep systemd && systemctl reboot
        xterm -e sudo reboot
        ;;
esac
