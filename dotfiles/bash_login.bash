#!/usr/bin/env bash

[[ ! -f ~/.use-bashrc ]] && exit 0

if [[ ! -f ~/.bash_login ]]; then
  ln -sv $PWD/bash/bash_login ~/.bash_login
else
  echo EXISTS: ~/.bash_login
fi

