#!/bin/bash

eval $(go env)

go_pkg_src=$GOROOT

find $go_pkg_src -name "*.go" -print > cscope.files
find . -name "*.go" -print >> cscope.files

if cscope -b -k; then
    echo "Done"
else
    echo "Failed"
    exit 1
fi
