#!/bin/sh
for i in $(ls ~/.use-*); do
    echo -n "touch ~/"
    basename $i
done
