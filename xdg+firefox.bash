#!/bin/bash

set -x

xdg-settings set default-web-browser firefox.desktop
xdg-settings set default-url-scheme-handler http firefox.desktop
xdg-settings set default-url-scheme-handler https firefox.desktop

xdg-settings get default-web-browser
xdg-settings get default-url-scheme-handler http
xdg-settings get default-url-scheme-handler https

