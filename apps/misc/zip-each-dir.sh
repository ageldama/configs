#!/bin/sh
for i in *; do
    if [ -d "${i}" ]; then
        cd "${i}"
        pwd
        zip -r -0 "../${i}.zip" *
        cd ..
    fi
done
