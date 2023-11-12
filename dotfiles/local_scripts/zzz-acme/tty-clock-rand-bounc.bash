#!/usr/bin/env bash

while true; do
  tty-clock -s -r -C $(($RANDOM % 8))
  read -t 1 -p 'C-c to quit (wait 1-sec) ... '
done

#x-terminal-emulator -e tty-clock -s -r -C $(perl -e 'print int(rand(8))')

