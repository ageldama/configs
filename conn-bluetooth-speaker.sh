#!/bin/sh
bluetoothctl <<EOF
power on
default-agent
connect XXXXX
EOF
