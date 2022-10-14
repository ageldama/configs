#!/bin/sh
SCRIPT_DIR=~/local/scripts
SEL=$(ls $SCRIPT_DIR | rofi -dmenu -p "Run: ") && sh ${SCRIPT_DIR}/${SEL}

