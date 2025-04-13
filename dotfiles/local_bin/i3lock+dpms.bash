#!/bin/bash

revert() {
  xset dpms 0 0 0
}

trap revert HUP INT TERM
xset +dpms dpms 5 5 5

BG_COLOR=111111
i3lock -n -c ${BG_COLOR}

revert

