#!/bin/sh
OPT2=""

if [ "FreeBSD" == $(uname) ]; then
  OPT2="-S"
fi

grep -oRSE ${OPT2} --no-filename '\.use-[a-zA-Z0-9_-]+' *  | sort | uniq
