#!/bin/bash

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
#
# Project        : STO 1 - RAID
# Name           : RAID0.sh
# Version        : 1.0
# Date created   : 11.10.2018
#
# Author         : Timothee Frily
#                  Michel Cruz
#                  Elie Platrier
#
# Purpose        : The user can create RAID 0
#
# Precondition   : Autorisation Root
#                  Package mdadm
#
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------

echo Création d\‘un périphérique RAID 0 dans le dossier "dev"
mdadm --create /dev/md0 --level=stripe --raid-devices=2 /dev/xvdh /dev/xvdf

echo Formatage du système de fichiers du RAID en ext4
mkfs -t ext4 /dev/md0

echo Création d\'un dossier "RAID0" dans "/mnt" qui comportera le système de fichiers du RAID
mkdir -p /mnt/RAID0

echo Montage du RAID dans le dossier "/mnt/RAID0"
mount /dev/md0 /mnt/RAID0

echo Récupération du PATH du RAID et de son UUID
MountPoint=/mnt/RAID0
UUIDmd0=$(blkid -s UUID -o value /dev/md0)

echo Afin de rendre le point de montage persistant
tofstab="UUID=$UUIDmd0 $MountPoint ext4 defaults,nofail 0 2"
echo $tofstab >> /etc/fstab

echo Rendre le raid peristant en cas de redémarrage
mdadm --verbose --detail --scan >> /etc/mdadm.confs

echo Vérification du niveau du RAID et le nombre de disques durs actifs
mdadm --detail /dev/md0
