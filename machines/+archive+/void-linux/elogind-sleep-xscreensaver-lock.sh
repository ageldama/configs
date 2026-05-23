#!/bin/sh
#
# /usr/libexec/elogind/system-sleep/xscreensaver-lock.sh

username=jhyun
userhome=/home/$username
export XAUTHORITY="$userhome/.Xauthority"
export DISPLAY=":0.0"

case "${1}" in
        pre)
            su $username -c "/bin/xscreensaver-command -lock" &
            sleep 1s;
            ;;
esac
