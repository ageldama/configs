#!/bin/sh

# https://gist.github.com/ericbolo/1261438048147b97316ff65f1ee105c6

# pactl list sources short
# pactl list sinks short

IN=alsa_input.usb-GeneralPlus_USB_Audio_Device-00.mono-fallback
OUT=alsa_output.platform-bcm2835_audio.digital-stereo

pacat -r --latency-msec=1 -d ${IN} | pacat -p --latency-msec=1 -d ${OUT}

