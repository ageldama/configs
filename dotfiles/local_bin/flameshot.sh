#!/bin/sh 

if command -v flameshot > /dev/null 2>&1; then
    flameshot "$@"
elif command -v flatpak > /dev/null 2>&1; then
    flatpak run org.flameshot.Flameshot "$@"
else
    xmessage "need 'flameshot' or 'flatpak run  ...flameshot'." -title "$0" -default okay -center -bg gray
    exit -1
fi
