#!/usr/bin/env bash

function xgamma_current {
    # NOTE: rgb중에서 red만.
    xgamma |& perl -ne 'print $1 if /(\d+\.\d+)/'
}

function xgamma_delta {
    delta=$1
    max=${2:-1.0}

    current=$(xgamma_current)
    
    new=$(echo print $delta + $current | perl)
    echo "NEW=$new / MAX=$max / DELTA=$delta"
    if [[ $max < $new ]]; then
        new=$max
    fi

    xgamma -gamma $new
}


while true # Forever = until ctrl+c
do
    echo "Press Up/Down ..."

    # https://stackoverflow.com/a/25065393
    # r: backslash is not for escape
    # s: silent
    # "n x": read x chars before returning
    read -rsn 1 t;
    case $t in
        A)
            # up
            xgamma_delta 0.1
            ;;
        B)
            # down
            xgamma_delta -0.1
            ;;
        C)
            # right
            ;;
        D)
            # left
            ;;
    esac;
done
