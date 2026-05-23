#!/usr/bin/env bash

[[ ! -f ~/.use-bashrc ]] && exit 0

if [[ ! -f ~/.bash_profile ]]; then
  ln -sv $PWD/bash/bash_profile ~/.bash_profile
else
  echo EXISTS: ~/.bash_profile
fi

