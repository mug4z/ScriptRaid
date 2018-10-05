#!/usr/bin/env bash

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
* Purpose           : The user can create raid0 to raid10
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
      raid0|raid1|raid5|raid6|raid10)
          break
          ;;
      *)

      echo "Invalid area"
          ;;
    esac
done


if [[ $raid = "raid0" ]]; then
  echo voici les disque que vous pouvez utilisé
  mdadm -E /dev/sd[a-z] | grep mdadm
  echo Combien de disque voulez-vous utilisé ?
  read numberDiskToUse
fi


# Créer un périphérique RAID 0 nommé "md0" dans le dossier "dev"
mdadm --create /dev/$VARIABLEADEFINIR --l=1 -n=2 /dev/"$VARIABLEADEFINIR"1 /dev/"$VARIABLEADEFINIR"1


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

# Sauvegarde mdadm config dans son fichier de configuration.
mdadm --verbose --detail --scan >> /etc/mdadm.confs
