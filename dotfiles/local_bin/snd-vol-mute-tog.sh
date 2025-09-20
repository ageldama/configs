#!/bin/sh

case $(uname) in
  FreeBSD)
    freebsd-mixer-mute-tog.pl
    ;;
  *)
    pactl-mute.pl sink toggle_default
    ;;
esac
