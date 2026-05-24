#!/bin/bash

LOCAL_TCL_DIR="${HOME}/local/tcl"

if [ -z "$TCLLIBPATH" ]; then
    export TCLLIBPATH="$LOCAL_TCL_DIR/lib"
else
    export TCLLIBPATH="$TCLLIBPATH $DIR"
fi

export PATH=$PATH:$LOCAL_TCL_DIR/bin
export TCL9_0_TM_PATH=$LOCAL_TCL_DIR/tm


export TCLLIBPATH="$TCLLIBPATH $HOME/local/tcl-cffi/lib"

