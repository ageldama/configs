#!/usr/bin/env bash

DIR=$(readlink -f "$(dirname "$0")")

# echo "$DIR"

"$DIR/enable.sh"
"$DIR/tap-to-click.sh"

