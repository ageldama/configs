#!/bin/bash

COUNT=0

while true; do
  ANS=$(dialog --menu "Count: ${COUNT}" 10 20 10 INC '+1' DEC '-1' 2>&1 > /dev/tty)

  if [[ $? != 0 ]]; then
    break
  fi

  case $ANS in
    INC)
      COUNT=$(expr $COUNT + 1)
      ;;
    DEC)
      COUNT=$(expr $COUNT - 1)
      ;;
  esac

done

