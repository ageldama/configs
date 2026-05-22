#!/bin/sh 

if command -v zathura > /dev/null 2>&1; then
    zathura "$@"
elif command -v flatpak > /dev/null 2>&1; then
    flatpak run org.pwmt.zathura "$@"
else
    xmessage "need 'zathura' or 'flatpak run  ...mpv'." -title "$0" -default okay -center -bg gray
    exit -1
fi
