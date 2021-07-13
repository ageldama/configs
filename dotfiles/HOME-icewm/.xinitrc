#!/bin/bash

OSNAME=`uname`

export PATH=$PATH:$HOME/local/bin

export TERMINAL=x-terminal-emulator

# fcitx/ibus + hangul
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
fcitx -s 5 -r -d &

# ssh / gnome-keyring
#    if ! pgrep ssh-agent; then
#    fi
#    ;;

# TODO ssh-agent
# TODO ssh-add + xterm


dbus-launch xbindkeys -n -p &

xset b off
#xset s on
#xset s 300

xscreensaver -no-splash &

# Mute all audio input
pactl-mute.pl source all &

# NetworkManager
nm-applet &

# Redshift
SEOUL_POS=37.566:126.977 # Seoul
which redshift-gtk
if [ $? -eq 0 ]; then
  redshift-gtk -l $SEOUL_POS &
else
  redshift -l $SEOUL_POS &
fi

# Compositor
which picom
if [ $? -eq 0 ]; then
  true #picom -b &
else
  true #compton -b &
fi

# Bluetooth
blueman-applet &

# Notification Logging
dbus-monitor "interface='org.freedesktop.Notifications', member='Notify'" >> /tmp/notifications-${USER}-${INVOCATION_ID}.log &


# bg-color
hsetroot -solid '#3f4058' &

# caps->ctrl
~/local/bin/caps-to-ctrl.sh 2 &

#
test -f ~/.xinitrc2 && ~/.xinitrc2


#
exec dbus-launch icewm ${1+"$@"}


###EOF
