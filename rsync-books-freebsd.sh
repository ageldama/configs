#!/bin/bash
set -x
rsync --progress --times -rzvh --delete \
      /home/myshare/books/ \
      aa@freebsd-samsung.local:/home2/aa/books


