#!/bin/sh
find . -type l -printf "%p\t" -exec ./fix-abs-symlink.pl {} \;

