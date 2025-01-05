#!/usr/bin/env perl

foreach my $i (qw<
  golang.org/x/tools/...
  github.com/rogpeppe/godef
  golang.org/x/lint/golint
  github.com/alecthomas/gometalinter
  github.com/mdempsky/gocode
  github.com/godoctor/godoctor
  github.com/derekparker/delve/cmd/dlv
  github.com/stretchr/testify/assert
  github.com/client9/misspell/cmd/misspell
  github.com/securego/gosec/cmd/gosec/...
>) {
  print $i;
  print qx(go install -v ${i});
}

#print qx(gometalinter -i -u); # NOTE: I fucking love IU!
