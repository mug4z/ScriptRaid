#---------------------------------------------#
#---------------------------------------------#
# Titre         :   Partition Disk
# Auteur        :   Michel Cruz
#
# Precondition  :   Root
#
# Version       :   12.09.2018
#---------------------------------------------#
#---------------------------------------------#

# Initialiser les disques durs et créer une partition pour chaque disque
fdisk /dev/[name-disk]1

# Ajouter une nouvelle partition
n

# Choisir le type de partition ; primaire dans ce cas
p

# Numéro de la partition
1

# Le premier secteur reste par défaut
\n

# Le dernier secteur reste par défaut
\n

# Modifier le type de partition
t

# Choisir le type de partition : RAID Linux auto
fd

# Afficher la table de partition du disque dur
p

# Ecrire la table de partition et quitter
w
