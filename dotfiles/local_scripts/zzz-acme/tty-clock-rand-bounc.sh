#!/bin/sh
x-terminal-emulator -e tty-clock -s -r -C $(perl -e 'print int(rand(8))')

