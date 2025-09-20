#!/bin/sh

case $(uname) in
  FreeBSD)
    x-terminal-emulator -e mixertui
    ;;
  *)
    pavucontrol
    ;;
esac
