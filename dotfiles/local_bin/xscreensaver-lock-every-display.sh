#!/bin/sh
for i in $(pidof xscreensaver); do
  display_val=$(cat /proc/${i}/environ | tr \\0 \\n | grep DISPLAY= | awk -F= '{print $2}')
  export DISPLAY=${display_val}
  xscreensaver-command -lock &
done
