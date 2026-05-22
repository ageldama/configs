#!/bin/sh 

if command -v mpv > /dev/null 2>&1; then
    mpv "$@"
elif command -v flatpak > /dev/null 2>&1; then
    flatpak run io.mpv.Mpv "$@"
else
    xmessage "need 'mpv' or 'flatpak run  ...mpv'." -title "$0" -default okay -center -bg gray
    exit -1
fi
