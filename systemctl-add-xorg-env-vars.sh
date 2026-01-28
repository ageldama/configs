#!/bin/sh
systemctl --user import-environment DISPLAY XAUTHORITY
systemctl --user show-environment

