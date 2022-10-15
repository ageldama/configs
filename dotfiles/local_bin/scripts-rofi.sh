#!/bin/sh
SCRIPT_DIR=~/local/scripts/
SEL=$(find $SCRIPT_DIR -executable -not -type d | rofi -dmenu -p "Script") && sh "${SEL}"

