#!/bin/bash
: '
***********************************************************************
* Project           : STO1 Raid
*
* Program name      : RAID6.sh
*
* Program version   : 1.0
*
* Author            : Timothee Frily
*
* Date created      : 08/10/2018
*
* Purpose           : The user can create raid6
*
* Revision History  :
*
* Date           Author         Revision (Date in DDMMYYY format)
* 08/10/2018   Timothee       Create the script
*
|**********************************************************************
'

# Prompt available raid
 mdadmAfichage =$(mdadm -E /dev/sd[a-z] | grep mdadm)
echo Veuiller choisir le premier disque libre pour le RAID6
read diskraid_1
echo ----------
echo Veuiller choisir le premier disque libre pour le RAID6
read diskraid_2
echo ---------
read -p "Veuiller choisir le troisième disque libre pour le RAID6" diskraid_3

read -p "Veuiller choisir le quatrième disque libre pour le RAID6" diskraid_4
read -p "Veuiller donner un nom à votre raid" raidname




# Create a raid5
mdadm  --create /dev/md0 --level=10 --name=$raidname --raid-devices=4 /dev/"$diskraid_1" /dev/"$diskraid_2" /dev/"$diskraid_3" /dev/"$diskraid_5"




# Formater le système de fichiers Linux du RAID
mkfs -t ext4 /dev/md0

# Créer un dossier qui comportera le système de fichier RAID
mkdir -p /mnt/raid1
# Monter le RAID dans le dossier "/ebs"
mount /dev/md0 /mnt/raid10

mountpoint=/mnt/raid10
uuidmdo=$(blkid -s UUID -o value /dev/md0 )

tofstab="UUID=$uuidmdo $mountpoint ext4 defaults 0 0"

echo $tofstab >> /etc/fstab
# Le système de fichiers devrait être monté maintenant. Vérifiez avec:
df -H

# Sauvegarde mdadm config dans son fichier de configuration.
mdadm --verbose --detail --scan >> /etc/mdadm.confs
