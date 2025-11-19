#!/usr/bin/env bash


if [[ -x ~/.local/bin/mise ]]; then
    eval "$(~/.local/bin/mise activate bash)"
fi



eval "$(direnv hook bash)"


#if [[ -d ~/.local/share/mise/shims ]]; then
#   export PATH=~/.local/share/mise/shims:$PATH
#fi



