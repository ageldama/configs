#!/usr/bin/env bash

expand_tilde() {
    tilde_less="${1#\~/}"
    [ "$1" != "$tilde_less" ] && tilde_less="$HOME/$tilde_less"
    printf '%s' "$tilde_less"
}

sdir="$1"
ddir="$2/"
ddir=$(expand_tilde $ddir)
uninst="$DOTFILES_UNINST"

if [ -z ${uninst} ]; then
  mkdir -p $(expand_tilde $ddir)
  echo "INSTALL: mkdir $ddir ..."
else
  echo "UNINSTALL: mkdir $ddir ..."
fi

for f in $(/bin/ls -Aa $sdir); do
  if [ "$f" = "." ] || [ "$f" = '..' ]; then
    continue
  fi

  sfn="$PWD/$1/$f"
  if [ -L "$sfn" ]; then
    sfn=$(readlink -f $sfn)
  fi

  dfn="$ddir/$f"
  dfn="$(expand_tilde $dfn)"

  if [ -z ${uninst} ]; then
    echo "(LN_S)   $sfn --> $dfn"
    if [ -L "${dfn}" ]; then
      echo " SKIPPING (existing)"
    else
      echo -n "  "; ln -sv "$sfn" "$dfn"
    fi
  else
    echo "(RM)   $dfn  ($sfn)"
    echo -n "  "; rm -v "$dfn"
  fi
done

