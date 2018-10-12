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
#                  Adriana Mota
#
# Purpose        : The user can delete a RAID
#
# Precondition   : Autorisation Root
#                  Package mdadm
#
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------

echo 1. Affichage des volumes
lsblk

read -p "2. Sélectionnez le RAID a supprimé (ex.: md127) : " md

sleep 1

echo 3. Suppression de RAID
UUIDmd=$(blkid -s UUID -o value /dev/$md)
sed -i "/${UUIDmd}/d" /etc/fstab

sleep 1

echo 4. Démontage du RAID
umount /dev/$md

sleep 1

echo 5. Arrêt des partitions et suppression du RAID
mdadm --stop /dev/$md

sleep 1

echo 5. Confirmation de la suppression du RAID
mdadm --remove /dev/$md

sleep 1

echo 6. Sélectionnez les volumes de l\'ancien RAID pour supprimer les SuperBlocks
lsblk

read -p "Veuillez choisir le premier volume : " disk_1
read -p "Veuillez choisir le deuxième volume : " disk_2
read -p "Veuillez choisir le troisième volume : " disk_3
read -p "Veuillez choisir le quatrième volume : " disk_4

sleep 1

echo 7. Suppression des SuperBlocks sur les volumes
mdadm --zero-superblock /dev/$disk_1 /dev/$disk_2 /dev/$disk_3 /dev/$disk_4

sleep 1

echo 8. Vérification de la suppression des SuperBlocks
mdadm -E /dev/$disk_1 /dev/$disk_2 /dev/$disk_3 /dev/$disk_4
