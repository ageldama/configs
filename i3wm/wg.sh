#!/bin/sh

FN=`find ~/P/wg/ -type f -not -path '*/\.git/*' | shuf -n1`
feh --bg-fill ${FN}
printf "Image-filename:\t${FN}\n"
