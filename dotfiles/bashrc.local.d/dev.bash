#!/usr/bin/env bash

if [[ -x ~/.local/bin/mise ]]; then
    eval "$(~/.local/bin/mise activate bash)"
fi

if [[ -d ~/.local/share/mise/shims ]]; then
    export PATH=~/.local/share/mise/shims:$PATH
fi

command -v direnv > /dev/null && eval "$(direnv hook bash)"



