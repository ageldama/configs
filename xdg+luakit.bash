#!/bin/bash

set -x

xdg-settings set default-web-browser luakit.desktop
xdg-settings set default-url-scheme-handler http luakit.desktop
xdg-settings set default-url-scheme-handler https luakit.desktop

xdg-settings get default-web-browser
xdg-settings get default-url-scheme-handler http
xdg-settings get default-url-scheme-handler https

