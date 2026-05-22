#!/bin/sh 

if command -v mcomix > /dev/null 2>&1; then
    mcomix "$@"
if command -v mcomix3 > /dev/null 2>&1; then
    mcomix3 "$@"
elif command -v flatpak > /dev/null 2>&1; then
    flatpak run org.sourceforge.mcomix "$@"
else
    xmessage "need 'mcomix', 'mcomix3' or 'flatpak run  ...mcomix'." -title "$0" -default okay -center -bg gray
    exit -1
fi
