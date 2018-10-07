#!/usr/bin/env bash

# Goal: Configure un raid5
# Prerequis : mdadm,dos2unix
# Author : Timothee Frily, Michel Cruz


#vérifie si root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


#vérifie si le package mdadm est installer sinon l'installe
MdadmCheck=$(which mdadm)
if [ -z "$MdadmCheck"  ]; then
  echo mdadm n est pas installer
   apt-get install mdadm
else
  echo mdadm est déjà installer
fi

#Vérifie si le package dos2unix est installer sinon l'installe
Dos2unixCheck=$(which dos2unix)
if [ -z "$Dos2unixCheck"  ]; then
  echo mdadm n est pas installer
   apt-get install dos2unix
else
  echo mdadm est déjà installer
fi

#Véririfie si aucun raid n'est configurer sur les disque
mdadm -E /dev/sd[a-z]

echo Veuiller indiquer le premier disque pour le raid10
read disque1
echo Maintenant le deuxième disque pour le raid10
read disque2
echo Pour finir le troisième disque pour le raid10
read disque3
echo Pour finir le dernier disque pour le raid10
read disque4


#Envoie les options en mémoire pour les injecté ensuite dans la commande fdisk
(
echo n
echo p
echo
echo
echo
echo p
echo l
echo t
echo fd
echo p
echo w
) | fdisk /dev/$disque1

(
echo n
echo p
echo
echo
echo
echo p
echo l
echo t
echo fd
echo p
echo w
) | fdisk /dev/$disque2

(
echo n
echo p
echo
echo
echo
echo p
echo l
echo t
echo fd
echo p
echo w
) | fdisk /dev/$disque3

(
echo n
echo p
echo
echo
echo
echo p
echo l
echo t
echo fd
echo p
echo w
) | fdisk /dev/$disque4

#Créer le raid5
mdadm --create /dev/md0 --level=10 -raid-devices=4 /dev/$disque1 /dev/$disque2 /dev/$disque3 /dev/$disque4
# Sauvegarde mdadm config dans son fichier de configuration.
mdadm --verbose --detail --scan >> /etc/mdadm.confs
