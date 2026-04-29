#!/bin/bash

DIR="${HOME}/local/sbcl"

if [[ -d "$DIR" ]]; then
    export PATH="$PATH:$DIR/bin"
fi
