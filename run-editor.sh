#!/bin/sh
if [[ -p $XDG_RUNTIME_DIR/emacs/server ]];
  emacsclient $@
else
  vim $@
fi

