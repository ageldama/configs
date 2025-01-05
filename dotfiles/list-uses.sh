#!/bin/sh
grep -oRE --no-filename '\.use-[a-zA-Z0-9_-]+' *  | sort | uniq
