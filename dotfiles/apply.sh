#!/usr/bin/env bash

export DOTFILES_UNINST=$1

while read p; do
  echo "${p}" | awk '{print "###", $1, "\t==>\t", $2; system(sprintf("sh ./_inst.sh \"%s\" \"%s\"", $1, $2)); }'
done <dirs.config

