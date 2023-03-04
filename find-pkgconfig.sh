#!/bin/sh

echo -n 'export PKG_CONFIG_PATH='
find $@ -name "*.pc" -printf "%h\n"  | sed 's/ /\\ /' | sort | uniq | paste -sd ':'

