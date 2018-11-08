#!/bin/sh
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
#
# Project        : Raid0 to Raid 6
# Name           : RAID0-5.sh
# Version        : 1.0
# Date created   : 11.10.2018
#
# Author         : Timothee Frily
#
#
# Purpose        : Grow raid 0 to raid 6
#
# Precondition   : Autorisation Root
#                  Package mdadm
#
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------


# Detect raid0

#Backup raid0 data in s3


# Add 2 disk for RAID4
# I need to see how mount new raid in read only
mdadm /dev/md127 --grow --level=5 --raid-devices=4 --add /dev/sdd /dev/sde

# Grow RAID0 to RAID 5
