#!/usr/bin/env bash

if [[ -d $HOME/.local/share/gem/ruby/current/bin ]]; then
    export PATH=$HOME/.local/share/gem/ruby/current/bin:$PATH
fi
