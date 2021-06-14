#!/bin/sh

sdir=HOME
ddir=~/local/bin

# TODO mkdir -pv ~/local/bin

for f in $(/bin/ls -Aa $sdir); do
  if [[ "$f" == "." ]] || [[ "$f" == '..' ]]; then
    continue
  fi

  fn=$PWD/local_bin/$f
  if [[ -L "$fn" ]]; then
    fn=$(readlink -f $fn)
  fi

  echo "$fn --> $ddir"
  # TODO ln -sv "$fn" ~/local/bin
done

