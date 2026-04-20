#!/bin/bash

DIR="${HOME}/local/tcl/lib"

if [ -z "$TCLLIBPATH" ]; then
    export TCLLIBPATH="$DIR"
else
    export TCLLIBPATH="$TCLLIBPATH $DIR"
fi
