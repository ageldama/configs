#!/bin/sh
SCRIPT_DIR=~/local/scripts/

FIND=find

NO_FREEBSD=<<'EO_CASE'
OSNAME=$(uname)

case $OSNAME in
  FreeBSD)
    FIND=/usr/local/bin/gfind
    ;;
esac
EO_CASE
#echo $FIND

SEL=$($FIND -L $SCRIPT_DIR -executable -not -type d | rofi -dmenu -p "Script") && sh "${SEL}"

