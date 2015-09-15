#!/bin/sh

FN=`find ~/wg/ -type f | shuf -n1`
feh --bg-fill ${FN}
printf "Image-filename:\t${FN}\n"
