#!/bin/bash

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
#
# Project        : STO 1 - RAID
# Name           : RAID1.sh
# Version        : 1.0
# Date created   : 11.10.2018
#
# Author         : Timothee Frily
#                  Michel Cruz
#                  Elie Platrier
#                  Adriana Mota
#
# Purpose        : The user can create RAID 1
#
# Precondition   : Autorisation Root
#                  Package mdadm
#
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------

echo 1. Création d\‘un périphérique RAID 1 dans le dossier "dev"
mdadm --create /dev/md0 --level=mirror --raid-devices=2 /dev/xvdh /dev/xvdf

sleep 1

echo 2. Formatage du système de fichiers du RAID en ext4
mkfs -t ext4 /dev/md0

sleep 1

echo 3. Création d\'un dossier "RAID1" dans "/mnt" qui comportera le système de fichiers du RAID
mkdir -p /mnt/RAID1

sleep 1

echo 4. Montage du RAID dans le dossier "/mnt/RAID1"
mount /dev/md0 /mnt/RAID1

sleep 1

echo 5. Récupération du PATH du RAID et de son UUID
MountPoint=/mnt/RAID1
UUIDmd0=$(blkid -s UUID -o value /dev/md0)

sleep 1

echo 6. Rendre le point de montage persistant
tofstab="UUID=$UUIDmd0 $MountPoint ext4 defaults,nofail 0 2"
echo $tofstab >> /etc/fstab

sleep 1

echo 7. Rendre le raid peristant en cas de redémarrage
mdadm --verbose --detail --scan >> /etc/mdadm.confs

sleep 1

echo 8. Vérification du niveau du RAID et le nombre de disques durs actifs
mdadm --detail /dev/md0

sleep 1

read -p "10. Redémarrez l\'ordinateur pour terminer la mise en place du RAID (o/n) :" confirm
  if [ $check = 'o' ]; then
    reboot
  else
    echo 'Il est possible que le RAID ne soit pas monté. Il est conseillé de rédmarrer votre machine'
  fi
