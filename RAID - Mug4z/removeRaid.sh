#!/usr/bin/env bash
: '
***********************************************************************
* Project           : STO1 Raid
*
* Program name      : removeRaid.sh
*
* Program version   : 1.0
*
* Author            : Timothee Frily
*
* Date created      : 07/10/2018
*
* Purpose           : Suppress Raid on for all
*
* Revision History  :
*
* Date           Author         Revision (Date in DDMMYYY format)
* 07/10/2018   Timothee       Create the script
*
|**********************************************************************
'
#Check if the user is root or not
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

read -p "Séléectionner le md a supprimer : " md

uuidmdo=$(blkid -s UUID -o value /dev/$md )
sed -i '/^'$uuidmdo'/d' /etc/fstab

#umount /dev/md0
umount /dev/$md

# Stop the partition of raid device on certain os you can't remove because is already remove
mdadm --stop /dev/$md

#Remove superblock on disk
mdadm --zero-superblock /dev/sd[b-c]
