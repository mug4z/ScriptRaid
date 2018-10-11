'#---------------------------------------------#
#---------------------------------------------#
# Informations Générales
#---------------------------------------------#
# Auteur        :   Elie Platrier
# Sources       :   Michel Cruz
# Objectif      :   Démontage automatisé des RAID
# Version       :   1.0
# Date          :   11.10.2018
#---------------------------------------------#
# Informations Complémentaires
#---------------------------------------------#
# Autorisations requises  : Root
# Paquets requis          : "mdadm"
#---------------------------------------------#
#---------------------------------------------#'

# Afficher les disques durs ajoutés au système
lsblk

# Afficher les partitions de chaque disque dur avec la commande "grep"
# Other solution : fdisk -l | grep sd
ls -l /dev | grep sd

# Vérifier s'il existe des blocs RAID
# Other solution : mdadm --examine /dev/sdb /dev/sdc /dev/sdd
mdadm -E /dev/sd[a-z]

# Démonter le RAID
umount /dev/md127

# Arrêter le RAID
mdadm --stop /dev/md127

# Supprimer le RAID | Sur certain OS, le RAID est supprimé quand il est stoppé
mdadm --remove /dev/md127

# Supprimer les SuperBlocks
mdadm --zero-superblock /dev/sd[b-c]

# Supprimer les partitions sur chaque disque
# fdisk /dev/[name disk]
