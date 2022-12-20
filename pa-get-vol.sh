#!/bin/sh

get_volume() {
  pacmd list-sinks | grep -A15 '* index' | perl -ne'/^\s+volume:.+\s+(\d+%)/ && print $1'

}

get_muted() {
  pacmd list-sinks|grep -A 15 '* index'|awk '/muted:/{ print $2 }'
}

get_sink_name() {
  pacmd list-sinks | grep '* index' -A1 |awk '/name:/{print $2}'
}

SINK_NAME=$(get_sink_name)
VOL=$(get_volume)
MUTED=$(get_muted)
MUTED_2=$(test "$MUTED" = "yes" && echo 'Muted' || echo 'Unmuted')

echo "$SINK_NAME : $MUTED_2 / $VOL"
