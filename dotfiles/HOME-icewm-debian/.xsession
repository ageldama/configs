#!/bin/sh
export PATH=$PATH:$HOME/local/bin

pgrep fcitx || fcitx -d &

if [ -z "${SSH_AUTH_SOCK}" ]; then
  eval "$(ssh-agent)"
fi

if [ -f /usr/bin/lxqt-openssh-askpass ]; then
  export SSH_ASKPASS=/usr/bin/lxqt-openssh-askpass
fi

#(ssh-add -L) || (ssh-add < /dev/null) &

# no beep
xset b off

xrdb -merge ~/.Xresources

killall icewmbg &
(sleep 1s; xsetroot -solid '#333333') &

(sleep 3s; ~/local/bin/caps-to-ctrl.sh) &

ssh-add < /dev/null &

SEOUL_POS=37.566:126.977 # Seoul
redshift-gtk -l $SEOUL_POS &


xscreensaver -no-splash &

dunst &

$HOME/.icewm/startup &

test -f ~/.xinitrc2 && ~/.xinitrc2

exec icewm


