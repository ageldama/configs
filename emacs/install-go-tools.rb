#!/usr/bin/env ruby

%w<
        golang.org/x/tools/...
        github.com/rogpeppe/godef
        github.com/golang/lint/golint
        github.com/alecthomas/gometalinter
        github.com/mdempsky/gocode
        github.com/godoctor/godoctor
        github.com/derekparker/delve/cmd/dlv
>.each do |i|
  p %x(go get -u -v #{i})
end

p %x(gometalinter -i -u) # NOTE: I fucking love IU!
