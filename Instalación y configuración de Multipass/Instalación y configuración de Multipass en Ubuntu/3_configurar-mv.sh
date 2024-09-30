#!/bin/bash

#######################################################################
# 
# Configuración de red e idioma de la MV.
# ATENCIÓN: Ejecutar el script EN la máquina virtual
#
#######################################################################

# Nombre de la MV basado en el nombre de la máquina host:
# nombremv="$(hostname -s)"

clear
date

echo "Configurando máquina virtual... 
Instalando resolución de nombres y servidor ssh... configurando idioma..."
sudo apt update
sudo apt -y upgrade
sudo apt install -y avahi-daemon winbind language-pack-es manpages-es
sudo update-locale LANG=es_AR.UTF-8

date
