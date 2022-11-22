#!/bin/bash

OSNAME=`uname`

export PATH=$PATH:$HOME/local/bin

export TERMINAL=x-terminal-emulator

# fcitx/ibus + hangul
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
fcitx -s 5 -r -d &

if [[ -z "${SSH_AUTH_SOCK}" ]]; then
  eval "$(ssh-agent)"
  # FreeBSD: `pkg add -y OpenSSH-askpass`
  ssh-add < /dev/null &
fi



dbus-launch dunst &

# NO-POLLING, instead:        killall -HUP xbindkeys
# dbus-launch xbindkeys -n -p &
if [[ -f ~/.use-xbindkeys ]]; then
  dbus-launch xbindkeys &
fi

xset b off
#xset s on
#xset s 300

xrdb -merge $HOME/.Xresources &

xscreensaver -no-splash &

# Mute all audio input
pactl-mute.pl source all &

# NetworkManager
nm-applet &

# Redshift
SEOUL_POS=37.566:126.977 # Seoul
which redshift-gtk
if [[ $? -eq 0 ]]; then
  redshift-gtk -l $SEOUL_POS &
else
  redshift -l $SEOUL_POS &
fi

# Compositor
which picom
if [[ $? -eq 0 ]]; then
  true #picom -b &
else
  true #compton -b &
fi

# Bluetooth
blueman-applet &

# Notification Logging
dbus-monitor "interface='org.freedesktop.Notifications', member='Notify'" >> /tmp/notifications-${USER}-${INVOCATION_ID}.log &


# bg-color
if [[ -x  ~/.fehbg ]]; then
    ~/.fehbg &
else
    hsetroot -solid '#3f4058' &
fi

# caps->ctrl
~/local/bin/caps-to-ctrl.sh 2 &

test -f ~/.use-keypad-pointer && setxkbmap -option keypad:pointerkeys

#
test -f ~/.xinitrc2 && ~/.xinitrc2

#
exec dbus-launch icewm ${1+"$@"}


###EOF
