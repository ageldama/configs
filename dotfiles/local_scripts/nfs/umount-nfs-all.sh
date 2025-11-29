#!/bin/sh
sudo umount -l `mount|grep nfs|awk '{print $3}'`
