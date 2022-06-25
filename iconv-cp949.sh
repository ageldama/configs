#!/bin/sh

for f in "$@"
do
  #echo "$f"
  iconv -sc -fcp949 < $1 > $f.tmp
  mv $f $f.bak
  mv $f.tmp $f
done


