#!/bin/bash

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
#
# Project        : STO 1 - RAID
# Name           : Delete_RAID.sh
# Version        : 1.0
# Date created   : 11.10.2018
#
# Author         : Timothee Frily
#                  Michel Cruz
#                  Elie Platrier
#
# Purpose        : The user can delete a RAID
#
# Precondition   : Autorisation Root
#                  Package mdadm
#
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------

echo 1. Affichage des disques durs et des partitions
lsblk

read -p "2. Sélectionnez le RAID a supprimé (ex.: md127) : " md

echo 3. Suppression de RAID
UUIDmd=$(blkid -s UUID -o value /dev/md127)
# work around supprime la dernière ligne sed '$d' /etc/fstab
sed -i '"/^$UUIDmd/d"' /etc/fstab

echo 4. Démontage du RAID
umount /dev/$md

echo 5. Arrêt des partitions et suppression du RAID
mdadm --stop /dev/$md

echo 5. Confirmation de la suppression du RAID
mdadm --remove /dev/md127

echo 6. Suppression des SuperBlocks sur les diques
mdadm --zero-superblock /dev/xvdf /dev/xvdi

echo 7. Vérification de la suppression des SuperBlocks
mdadm -E /dev/xvdh /dev/xvdf
