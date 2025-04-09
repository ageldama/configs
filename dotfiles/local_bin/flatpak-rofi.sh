#!/bin/sh
APP_ID=$(flatpak list --app --columns application |tail -n +1| rofi -p 'flatpak app to run' -dmenu ) && flatpak run $APP_ID

