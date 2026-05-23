#!/bin/sh
OPT2=""

if [ "$(uname)" = "FreeBSD" ]; then
  OPT2="-S"
fi

grep -oRE ${OPT2} --no-filename '\.use-[a-zA-Z0-9_-]+' *  | sort | uniq
