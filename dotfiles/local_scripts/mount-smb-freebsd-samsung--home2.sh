#!/bin/bash

SMB_USER=aamadleg

read -s -p "SMB Password (for ${SMB_USER}): " SMB_PASSWD

sudo mount -t cifs -o vers=3.0,user=${SMB_USER},password=${SMB_PASSWD} //freebsd-samsung.local/home2 /home/aamadleg/mnts/freebsd-samsung--home2/



