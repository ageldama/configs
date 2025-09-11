#!/bin/sh
grep -oRSE --no-filename '\.use-[a-zA-Z0-9_-]+' *  | sort | uniq
