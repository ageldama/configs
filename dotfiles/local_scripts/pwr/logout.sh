#!/bin/sh

zenity --question --text='log-ff?' || exit -1

xterm -e loginctl terminate-session
