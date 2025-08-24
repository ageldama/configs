#!/bin/sh
export TERM=linux
sudo setterm --blank 1 </dev/tty1
sudo setterm --powerdown 1 </dev/tty1
sudo setterm --powersave powerdown </dev/tty1
sudo setterm --blank poke </dev/tty1
