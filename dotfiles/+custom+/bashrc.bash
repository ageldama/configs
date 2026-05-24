#!/usr/bin/env bash

[[ ! -f ~/.use-bashrc ]] && exit 0

# if [[ -f $HOME/.profile && ! -f $HOME/.bash_profile ]]; then
#   ln -s $HOME/.profile $HOME/.bash_profile
# fi

if grep -q "source ~/.bashrc.d/bashrc2" ~/.bashrc; then
  echo "|- ALREADY APPLIED."
  exit 0
else
  echo "|- APPLYING."
  printf "\nsource ~/.bashrc.d/bashrc2\n\n" >> ~/.bashrc
fi

