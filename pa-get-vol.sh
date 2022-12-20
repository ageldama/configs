#!/bin/sh

get_sink_name() {
  pactl info | perl -ne '/default sink:\s+(.+)/i && print $1'
}

get_sink_info() {
    NAME=$(get_sink_name)
    pactl list sinks | grep "Name: $NAME" -A15
}

get_volume() {
   get_sink_info | perl -ne '/^\s+volume:.+\s+(\d+%)/i && print $1'
}

get_muted_yesno() {
  get_sink_info | perl -ne '/mute:\W+(\w+)/i && print $1'
}

SINK_NAME=$(get_sink_name)
VOL=$(get_volume)
MUTED=$(get_muted_yesno)
MUTED_2=$(test "$MUTED" = "yes" && echo 'Muted' || echo 'Unmuted')

echo "$SINK_NAME : $MUTED_2 / $VOL"
