#!/usr/bin/env bash

[[ ! -f ~/.use-bashrc ]] && exit 0

if grep "source ~/.bashrc.d/bashrc2" ~/.bashrc; then
  # echo found
  exit 0
else
  # echo not-found
  printf "\nsource ~/.bashrc.d/bashrc2\n\n" >> ~/.bashrc
fi

