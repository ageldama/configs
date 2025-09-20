#!/bin/sh

case $(uname) in
  FreeBSD)
    freebsd-mixer-vol-dn.pl
    ;;
  *)
    pa-vol-dn.sh
    ;;
esac
