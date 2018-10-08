#!/bin/bash

: '
***********************************************************************
* Project           : STO1 Raid
*
* Program name      : RAID1.sh
*
* Program version   : 1.0
*
* Author            : Timothee Frily
*
* Date created      : 08/10/2018
*
* Purpose           : The user can create raid1
*
* Revision History  :
*
* Date           Author         Revision (Date in DDMMYYY format)
* 08/10/2018   Timothee       Create the script
*
|**********************************************************************
'

# Afficher les disques durs ajoutés au système
#lsblk

# Afficher les partitions de chaque disque dur avec la commande "grep"
# Other solution : fdisk -l | grep sd
#ls -l /dev | grep sd

# Vérifier s'il existe des blocs RAID
# Other solution : mdadm --examine /dev/sdb /dev/sdc /dev/sdd
 mdadmAfichage =$(mdadm -E /dev/sd[a-z] | grep mdadm)
echo Veuiller choisir le premier disque libre pour le RAID1
read diskraid_1
echo ----------
echo Veuiller choisir le premier disque libre pour le RAID1
read diskraid_2



# Créer un périphérique RAID 0 nommé "md0" dans le dossier "dev"
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/"$diskraid_1" /dev/"$diskraid_2"


# Vérifier le niveau de RAID et les périphériques inclus
#more /proc/mdstat

# Vérifier le niveau de RAID, le nombre de disques durs actifs
#mdadm --detail /dev/md0

# Formater le système de fichiers Linux du RAID
mkfs -t ext4 /dev/md0

# Créer un dossier qui comportera le système de fichier RAID
mkdir -p /ebs

# Monter le RAID dans le dossier "/ebs"
mount /dev/md0 /ebs

# Le système de fichiers devrait être monté maintenant. Vérifiez avec:
df -H

# Sauvegarde mdadm config dans son fichier de configuration.
mdadm --verbose --detail --scan >> /etc/mdadm.confs
