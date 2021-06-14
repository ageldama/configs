#!/bin/sh

mkdir -pv ~/local/bin

for f in $(ls local_bin); do
  fn=$PWD/local_bin/$f
  if [[ -L "$fn" ]]; then
    fn=$(readlink -f $fn)
  fi

  ln -sv "$fn" ~/local/bin
done

