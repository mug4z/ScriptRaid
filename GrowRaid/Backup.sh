#!/usr/bin/env bash

# Create symbolic link
#sudo ln -s /mnt/RAID0 RAID

# Put mountpoint in readonly
umount /mnt/RAID0
mount -o ro /dev/md127 /mnt/RAID0


# Backup in s3
aws s3 cp RAID s3://raidevolution.actualit.info/raidevolutionbackup/ --recursive

# Check if all data is there
aws s3 ls s3://raidevolution.actualit.info/raidevolutionbackup/ --recursive
