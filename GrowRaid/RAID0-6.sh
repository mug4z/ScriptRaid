#!/bin/sh
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
#
# Project        : Transfer data from raid0 to raid6
# Name           : RAID0-5.sh
# Version        : 1.0
# Date created   : 10.11.2018
#
# Author         : Timothee Frily
#                  Kévin Gilgen
#
#
# Purpose        : Grow raid 0 to raid 6
#
# Precondition   : Autorisation Root
#                  Package mdadm
#
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------

# Create symbolic link
ln -s /mnt/RAID0 /RAID

# Put mountpoint in readonly
umount /mnt/RAID0
mount -o ro /dev/md126 /mnt/RAID0

read -p "Continue ?"

# Backup in s3
aws s3 cp /RAID s3://raidevolution.actualit.info --recursive

read -p "Continue"

# Transfer from raid 0 to raid 6
sudo rsync -a  /RAID/. /mnt/RAID6

read -p "Continue ?"

# Create hash for folder mountpoint raid0
sudo find /mnt/RAID0/ -type f -exec md5sum {} + | sort > /dev/null 2> raid0.txt

read -p "Continue ?"

# Create hash for folder mountpoint raid0
sudo find /mnt/RAID6/ -type f -exec md5sum {} + | sort > /dev/null 2> raid6.txt

# Compare the two hashes to check if all file are there
diff -u raid0.txt raid6.txt

read -p "Continue ?"

#Remove the old symbolic link
rm /RAID

#Change symbolic link
ln -s /mnt/RAID6 /RAID

read -p "Continue ?"

#Unmount the old raid array
umount /mnt/RAID0
