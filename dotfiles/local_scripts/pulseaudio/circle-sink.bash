#!/bin/bash

OUT=$({ pa-circle-sink.pl; } 2>&1); notify-send "${OUT}"

