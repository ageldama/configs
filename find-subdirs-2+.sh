#!/bin/sh
find . -type d -depth 1 -print -exec sh -c "find {} -type d -depth 1 | wc -l" \; | sed 'N;s/\n/ /' | awk '{if($2>1){print $1, $2}}' | sort -k 2
