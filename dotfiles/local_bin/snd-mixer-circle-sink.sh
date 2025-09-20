#!/bin/sh

case $(uname) in
  FreeBSD)
    freebsd-mixer-circle-sink.pl
    ;;
  *)
    pa-circle-sink.pl
    ;;
esac
