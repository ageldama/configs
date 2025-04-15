#!/bin/bash

set -x

xdg-settings set default-web-browser org.qutebrowser.qutebrowser.desktop
xdg-settings set default-url-scheme-handler http org.qutebrowser.qutebrowser.desktop
xdg-settings set default-url-scheme-handler https org.qutebrowser.qutebrowser.desktop

xdg-settings get default-web-browser
xdg-settings get default-url-scheme-handler http
xdg-settings get default-url-scheme-handler https

