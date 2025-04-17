#!/usr/bin/env bash

[[ ! -f ~/.use-zsh ]] && exit 0

if grep "source ~/.zshrc.local" ~/.zshrc; then
  # echo found
  exit 0
else
  # echo not-found
  printf "\nsource ~/.zshrc.local\n\n" >> ~/.zshrc
fi

