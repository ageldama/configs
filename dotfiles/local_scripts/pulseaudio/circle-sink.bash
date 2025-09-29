#!/usr/bin/env bash

OUT=$({ pa-circle-sink.pl; } 2>&1); notify-send "New default sink: ${OUT}"

