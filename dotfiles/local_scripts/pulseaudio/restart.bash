#!/usr/bin/env bash

if systemctl --user | grep pulseaudio; then
    echo SYSTEMD
    systemctl --user restart pulseaudio
else
    echo MANUAL
    pulseaudio -k
    pulseaudio -D
fi

