#!/usr/bin/env bash

[[ ! -f ~/.use-zsh ]] && exit 0

if [[ ! -f ~/.zlogin ]]; then
  ln -sv $PWD/zsh/zlogin ~/.zlogin
else
  echo EXISTS: ~/.zlogin
fi

