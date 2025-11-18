#!/bin/bash

SMB_USER=A
#SMB_HOST=freebsd-samsung.local
#SMB_IP=$(getent hosts $SMB_HOST | head -n1 | awk '{print $1}')
SMB_IP=10.42.0.1
SMB_HOST=$SMB_IP
SMB_SHARE=A

MNT_UID=$(id -u)
MNT_GID=$(id -g)


read -s -p "SMB Password (for ${SMB_USER} @ ${SMB_IP} == ${SMB_HOST}): " SMB_PASSWD

sudo mount -t smb3 -o vers=3.0,user=${SMB_USER},password=${SMB_PASSWD},uid=$MNT_UID,gid=$MNT_GID //${SMB_IP}/${SMB_SHARE} ${HOME}/mnts/${SMB_HOST}-${SMB_SHARE}/
#sudo mount -t cifs -o vers=3.0,user=${SMB_USER},password=${SMB_PASSWD},uid=$MNT_UID,gid=$MNT_GID //${SMB_IP}/${SMB_SHARE} ${HOME}/mnts/${SMB_HOST}-${SMB_SHARE}/



