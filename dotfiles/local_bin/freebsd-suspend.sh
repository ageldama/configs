#!/bin/sh

# TODO .use-xscreensaver
export DISPLAY=":0"
su -m aamadleg -c "xscreensaver-command -lock"
sleep 3

/usr/sbin/acpiconf -s 3
