#!/bin/sh

# /dev/sda1 on /home2 type ext4 (rw,noatime)
# /dev/disk/by-id/wwn-0x50014ee1021b8d72

# /dev/sdc2 on /home3 type ext4 (rw,noatime)
# /dev/disk/by-id/ata-TOSHIBA_DT01ACA050_94197XXGS


for i in /dev/disk/by-id/wwn-0x50014ee1021b8d72 /dev/disk/by-id/ata-TOSHIBA_DT01ACA050_94197XXGS; do
    echo $i    
    udisksctl power-off -b $i || true
done
 

