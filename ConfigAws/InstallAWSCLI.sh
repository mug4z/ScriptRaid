#!/usr/bin/env bash

#Goal : Script the installation of awscli
#Author : Timothee Frily
#
#Prerequis :python 2.7 or python 3.x, pip

#Inisialisation de la variable pour mettre le texte en rouge lors d'erreur
RED='\033[0;31m'

#Inisialisation de la variable pour mettre le texte en vert lors d'action réussite
GREEN='\033[0;32m'

#Fonction pour le check de l'installation de package
function CheckInstallationPackage {
  installcheck=$(which $1)
  if [[ -z $installcheck ]]; then
    printf "${RED}Le package $1 c'est mal installé"
  else
    printf "${GREEN}L'installation du package $1 est réussie !!!!!"
  fi
}

#vérifie si root si pas root exit le script


if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être lancé en temp qu'utilisateur root" 1>&2
   exit 1
fi
#----Début des vérification des package nécessaires----#
# Check de python
pythonCheck=$(which python)
if [[ -z $pythonCheck ]]; then
  echo "python n'est pas installé"
  echo installation de python
  apt-get install python
  #L'installation c'est bien passé
  CheckInstallationPackage python
else
  echo python déjà installé
fi

#Check de pip
pipCheck=$(which pip)
if [[ -z $pipCheck ]]; then
  echo "pip n'est pas installé"
  echo installation de pip
#Va chercher le script d'installation de pip pour pouvoir installé la dernière version de pip
  curentdirectory=$(pwd)
  echo "Téléchargement du script d'installation de pip dans $curentdirectory"
  curlCheck=$(which curl)
  if [[ -z $curlCheck ]]; then
    apt-get install curl
  fi
 curl -O https://bootstrap.pypa.io/get-pip.py
 echo Installation de pip
 chmod +x get-pip.py
 python get-pip.py

 #Vérifie si l'installation c'est bien passé
 CheckInstallationPackage pip
else
  echo pip est déjà installé
fi
#----Fin des vérification des package nécessaires----#

#----Début de l'installation de awscli---#
echo "Check de l'installation de awscli"
if [[ -e ~/.local/bin/aws  ]]; then
    clear
    echo "${GREEN}aws est déjà installer have fun !!!!"
  if [[ -e ~/.local/bin/aws  ]]; then
      clear
      echo "${GREEN}aws c'est bien installé"
  else
      clear
      echo "${RED}aws ce n'est pas bien installé"
  fi
else
  echo "aws n'est pas installé début de l'installation"
  pip install awscli --upgrade --user
fi
#----Fin de l'installation de awscli---#

#Ajout du path dans le fichier .bashrc
clear
 echo Ajout de aws dans le path de bash


 #Permet ensuite de pouvoir lancé la commande aws depuis n'importe ou sans spécifier tout le chemin
 echo  "export PATH=~/.local/bin:$PATH" >> ~/.bashrc

 source ~/.bashrc

echo "----Test si la commande a bien été ajouté au .bashrc------"
awsGOOD=$( aws )
if [[ -z $awsGOOD ]]; then

fi
