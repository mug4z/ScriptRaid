#!/usr/bin/env bash

# Create hash for folder mountpoint raid0
ls /mnt/RAID0/ | md5sum > raid0.txt
# Transfer from raid 0 to raid 6
sudo rsync -a  RAID/. /mnt/RAID6

# Create hash for folder mountpoint raid0
ls /mnt/RAID6/ | md5sum > raid6.txt
# Compare the two hashes to check if all file are there
diff -u raid0.txt raid6.txt

#Remove the old symbolic link
rm RAID

#Change symbolic link
ln -s /mnt/RAID6 RAID
