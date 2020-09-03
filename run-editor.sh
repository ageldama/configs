#!/bin/sh
FILE="$XDG_RUNTIME_DIR/emacs/server"
# echo $FILE
# ls -lh $FILE
if [[ -e "$FILE" ]]; then
    emacsclient "$@"
else
    vim "$@"
fi

