#!/bin/sh

while true; do
    feh --bg-fill `find ~/wg/ -type f | shuf -n1` || break
    sleep 5m
done
