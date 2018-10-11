#!/bin/bash

: '
***********************************************************************
* Project           : STO1 Raid
*
* Program name      : RAID0NOFdisk.sh
*
* Program version   : 1.0
*
* Author            : Timothee Frily
*
* Date created      : 09/10/2018
*
* Purpose           : The user can create raid0
*
* Revision History  :
*
* Date           Author         Revision (Date in DDMMYYY format)
* 09/10/2018   Timothee       Create the script
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
echo Veuiller choisir le premier disque libre pour le RAID0
read diskraid_1
echo ----------
echo Veuiller choisir le premier disque libre pour le RAID0
read diskraid_2



# Créer un périphérique RAID 0 nommé "md0" dans le dossier "dev"
mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/"$diskraid_1" /dev/"$diskraid_2"

# Formater le système de fichiers Linux du RAID
mkfs -t ext4 /dev/md0


# Créer un dossier qui comportera le système de fichier RAID
mkdir -p /mnt/raid0

# Monter le RAID dans le dossier "/ebs"
mount /dev/md0 /mnt/raid0
mountpoint=/dev/raid0
#Select the uuid of the raid
 uuidmdo=$(blkid -s UUID -o value /dev/md0 )

tofstab="UUID=$uuidmdo $mountpoint ext4 defaults 0 0"

echo $tofstab >> /etc/fstab

# Save the configuration .
mdadm --verbose --detail --scan >> /etc/mdadm.confs
