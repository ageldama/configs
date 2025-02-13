#!/bin/sh
xrandr -q |perl -wlne "/^(?<disp>.+) connected/ and print $+{disp}" | xargs -I '{}' xrandr --auto --output '{}'
