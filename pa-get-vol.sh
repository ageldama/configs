#!/bin/sh

getsink() {
  pacmd list-sinks | awk '/index:/{i++} /* index:/{print i; exit}'
}

get_volume() {
  pactl list sinks | tr ' ' '\n' | grep -m1 '%' | tr -d '%'
}

get_muted() {
  pacmd list-sinks|grep -A 15 '* index'|awk '/muted:/{ print $2 }'
}

VOL=$(get_volume)
MUTED=$(get_muted)

printf "Vol: %s%% %s\n" $VOL $(test "$MUTED" = "yes" && echo 'Muted' || echo 'Unmuted')
