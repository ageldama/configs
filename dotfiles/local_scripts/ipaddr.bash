#!/usr/bin/env bash

if command -v ip &> /dev/null; then
    ip a
else
    ifconfig
fi

read -n 1 -s -p ">>> Press any key"
