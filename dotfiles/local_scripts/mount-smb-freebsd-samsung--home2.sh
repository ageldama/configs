#!/bin/bash

SMB_USER=aamadleg
SMB_HOST=freebsd-samsung.local
SMB_IP=$(getent hosts $SMB_HOST | head -n1 | awk '{print $1}')


read -s -p "SMB Password (for ${SMB_USER} @ ${SMB_IP} == ${SMB_HOST}): " SMB_PASSWD

sudo mount -t cifs -o vers=3.0,user=${SMB_USER},password=${SMB_PASSWD} //${SMB_IP}/home2 ${HOME}/mnts/freebsd-samsung--home2/



