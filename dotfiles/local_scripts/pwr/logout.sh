#!/bin/sh

yesno.tcl 'log-ff?' || exit -1

xterm -e loginctl terminate-session ${XDG_SESSION_ID}

