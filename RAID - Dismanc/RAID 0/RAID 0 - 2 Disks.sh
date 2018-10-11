#---------------------------------------------#
#---------------------------------------------#
# Auteur        :   Michel Cruz
# Goal          :   Mount RAID 0
# Version       :   1.0
#
# Precondition  :   Root
#                   Package "mdadm"
#---------------------------------------------#
#---------------------------------------------#

# Afficher les disques durs ajoutés au système
lsblk

# Afficher les partitions de chaque disque dur avec la commande "grep"
# Autre solution : fdisk -l | grep sd
ls -l /dev | grep sd

# Vérifier s'il existe des blocs RAID
# Autre solution : mdadm --examine /dev/sdb /dev/sdc /dev/sdd
mdadm -E /dev/sd[a-z]

# Initialiser les disques durs et créer une partition pour chaque disque
# fdisk /dev/[name disk]

# Créer un périphérique RAID 0 nommé "md0" dans le dossier "dev"
mdadm --create /dev/md0 --level=stripe --raid-devices=2 /dev/sd[b-c]1

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
