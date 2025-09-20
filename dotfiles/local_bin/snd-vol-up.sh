#!/bin/sh

case $(uname) in
  FreeBSD)
    freebsd-mixer-vol-up.pl
    ;;
  *)
    pa-vol-up.sh
    ;;
esac
