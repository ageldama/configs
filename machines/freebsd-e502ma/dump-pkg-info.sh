#!/bin/sh
pkg info|perl -lane '{$F[0] =~ s/-[0-9].*//; print $F[0] unless /^FreeBSD/ }'
