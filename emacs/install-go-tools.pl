#!/usr/bin/env perl

foreach my $i (qw(
  golang.org/x/tools/...
  github.com/rogpeppe/godef
  github.com/golang/lint/golint
  github.com/alecthomas/gometalinter
  github.com/mdempsky/gocode
  github.com/godoctor/godoctor
  github.com/derekparker/delve/cmd/dlv
  github.com/stretchr/testify/assert
)) {
  print $i;
  print qx(go get -u -v ${i});
}

#print qx(gometalinter -i -u); # NOTE: I fucking love IU!
