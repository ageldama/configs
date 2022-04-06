#!/bin/sh
pacmd list-sinks | grep -e 'name:' -e 'index'
