#!/bin/bash

OUT=$({ pa-circle-sink.bash; } 2>&1); notify-send "${OUT}"

