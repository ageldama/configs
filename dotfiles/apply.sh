#!/bin/bash

while read p; do
  echo "${p}" | awk '{print "###", $1, "\t==>\t", $2; }'
done <dirs.config

