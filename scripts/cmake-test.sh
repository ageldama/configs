#!/bin/sh
cmake -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON "$@"
