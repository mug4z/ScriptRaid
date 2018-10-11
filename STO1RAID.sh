#!/usr/bin/env bash

# Salut MICHEL
: '
***********************************************************************
* Project           : STO1 Raid
*
* Program name      : STO1RAID.sh
*
* Program version   : 1.0
*
* Author            : Timothee Frily
*
* Date created      : 05/10/2018
*
* Purpose           : The user can create raid0 to raid6
*
* Revision History  :
*
* Date           Author         Revision (Date in DDMMYYY format)
* 05/10/2018   Timothee       Create the script
*
|**********************************************************************
'
#Check if the user is root or not
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


#check the installation of mdadm and install it if needed
MdadmCheck=$(which mdadm)
if [ -z "$MdadmCheck"  ]; then
  echo "mdadm n'est pas installer"
   apt-get install mdadm
else
  echo "mdadm est déjà installer"
fi


echo "Please choose the raid you need"

select raid in raid0 raid1 raid5 raid6 raid10
do
    case $raid in
      raid0|raid1|raid5|raid6)
          break
          ;;
      *)

      echo "Invalid area"
          ;;
    esac
done



if [[ $raid = "raid0" ]]; then
  mdadmAfichage=$(mdadm -E /dev/sd[a-z] | grep mdadm)

 echo Veuiller choisir le premier disque libre pour le RAID1
 read diskraid_1
 echo ----------
 echo Veuiller choisir le deuxième disque libre pour le RAID1
 read diskraid_2

 # Créer un périphérique RAID 0 nommé "md0" dans le dossier "dev"
 mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/"$diskraid_1" /dev/"$diskraid_2"

 # Formater le système de fichiers Linux du RAID
 mkfs -t ext4 /dev/md0

 # Vérifier le niveau de RAID et les périphériques inclus
 #more /proc/mdstat

 # Vérifier le niveau de RAID, le nombre de disques durs actifs
 #mdadm --detail /dev/md0

 # Créer un dossier qui comportera le système de fichier RAID
 mkdir -p /RAID0

 # Monter le RAID dans le dossier "/ebs"
 mount /dev/md0 /ebs

 # Le système de fichiers devrait être monté maintenant. Vérifiez avec:
 df -H
 # Sauvegarde mdadm config dans son fichier de configuration.
 mdadm --verbose --detail --scan >> /etc/mdadm.confs
 echo
fi


if [[ $raid = "raid1" ]]; then
 mdadmAfichage=$(mdadm -E /dev/xvd[a-z] | grep mdadm)
 echo Veuiller choisir le premier disque libre pour le RAID1
 read diskraid_1
 echo ----------
 echo Veuiller choisir le deuxième disque libre pour le RAID1
 read diskraid_2

 # Créer un périphérique RAID 0 nommé "md0" dans le dossier "dev"
 mdadm --create /dev/md0 --l=1 -n=2 /dev/"$diskraid_1" /dev/"$diskraid_2"

  # Vérifier le niveau de RAID et les périphériques inclus
  more /proc/mdstat

  # Vérifier le niveau de RAID, le nombre de disques durs actifs
  mdadm --detail /dev/md0

  # Formater le système de fichiers Linux du RAID
  mkfs -t ext4 /dev/md0

  # Créer un dossier qui comportera le système de fichier RAID
  mkdir -p /ebs

  # Monter le RAID dans le dossier "/ebs"
  mount /dev/md0 /ebs

  # Le système de fichiers devrait être monté maintenant. Vérifiez avec:
  df -H


  lsblk -o NAME,UUID
  # Sauvegarde mdadm config dans son fichier de configuration.
  mdadm --verbose --detail --scan >> /etc/mdadm.confs
fi

if [[ $raid = "raid5" ]]; then
  mdadmAfichage=$(mdadm -E /dev/sd[a-z])
  cat $mdadmAfichage | grep mdadm
  echo Veuiller indiquer le premier disque pour le raid5
  read disque1
  echo Maintenant le deuxième disque pour le raid5
  read disque2
  echo Pour finir le dernier disque pour le raid5
  read disque3

  # Vérifier le niveau de RAID et les périphériques inclus
  more /proc/mdstat

  # Vérifier le niveau de RAID, le nombre de disques durs actifs
  mdadm --detail /dev/md0

  # Formater le système de fichiers Linux du RAID
  mkfs -t ext4 /dev/md0

  # Créer un dossier qui comportera le système de fichier RAID
  mkdir -p /ebs

  # Monter le RAID dans le dossier "/ebs"
  mount /dev/md0 /ebs

  # Le système de fichiers devrait être monté maintenant. Vérifiez avec:
  df -H

  #Créer le raid5
  mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/$disque1 /dev/$disque2 /dev/$disque3
  # Sauvegarde mdadm config dans son fichier de configuration.
  mdadm --verbose --detail --scan >> /etc/mdadm.confs

fi

if [[ $raid = "raid5" ]]; then
  mdadmAfichage=$(mdadm -E /dev/sd[a-z])
  cat $mdadmAfichage | grep mdadm
  echo Veuiller indiquer le premier disque pour le raid6
  read disque1
  echo Maintenant le deuxième disque pour le raid6
  read disque2
  echo Pour finir le dernier disque pour le raid6
  read disque3
  echo Dernier disque pour le raid6
  read disque4
  # Vérifier le niveau de RAID et les périphériques inclus
  more /proc/mdstat

  # Vérifier le niveau de RAID, le nombre de disques durs actifs
  mdadm --detail /dev/md0

  # Formater le système de fichiers Linux du RAID
  mkfs -t ext4 /dev/md0

  # Créer un dossier qui comportera le système de fichier RAID
  mkdir -p /ebs

  # Monter le RAID dans le dossier "/ebs"
  mount /dev/md0 /ebs

  # Le système de fichiers devrait être monté maintenant. Vérifiez avec:
  df -H

  #Créer le raid5
  mdadm --create /dev/md0 --level=6 --raid-devices=4 /dev/$disque1 /dev/$disque2 /dev/$disque3 /dev/$disque4
  # Sauvegarde mdadm config dans son fichier de configuration.
  mdadm --verbose --detail --scan >> /etc/mdadm.confs

fi

if [[ $raid = "raid10" ]]; then
  mdadmAfichage=$(mdadm -E /dev/sd[a-z])
  cat $mdadmAfichage | grep [mdadm.*]
  echo Veuiller indiquer le premier disque pour le raid5
  read disque1
  echo Maintenant le deuxième disque pour le raid5
  read disque2
  echo Pour finir le dernier disque pour le raid5
  read disque3
  echo Dernier disque pour le raid10
  read disque4
  # Vérifier le niveau de RAID et les périphériques inclus
  more /proc/mdstat

  # Vérifier le niveau de RAID, le nombre de disques durs actifs
  mdadm --detail /dev/md0

  # Formater le système de fichiers Linux du RAID
  mkfs -t ext4 /dev/md0

  # Créer un dossier qui comportera le système de fichier RAID
  mkdir -p /ebs

  # Monter le RAID dans le dossier "/ebs"
  mount /dev/md0 /ebs

  # Le système de fichiers devrait être monté maintenant. Vérifiez avec:
  df -H

  #Create raid10
  mdadm --create /dev/md0 --level=10 -raid-devices=4 /dev/$disque1 /dev/$disque2 /dev/$disque3 /dev/$disque4

fi
