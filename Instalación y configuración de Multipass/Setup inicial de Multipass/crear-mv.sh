#!/bin/bash

##############################################################################################
#                                                                                            #
#  ¡Importante! Este script supone que Multipass está actualmente instalado en su sistema.   #
#                                                                                            #
#  El propósito del mismo es crear una máquina virtual (MV) con los parámetros de nombre, -  #
#  cantidad de procesadores, tamaño de disco y cantidad de memoria RAM deseados.             #
#                                                                                            #
#  Una vez configurada la MV en Multipass, se inicia una instancia y se instala en ella -    #
#  algunos paquetes que necesitaremos para trabajar en la cátedra.                           #
#                                                                                            #
##############################################################################################

# Nombre de la MV basado en el nombre de la máquina host:
nombremv="mv-sgbd"

# Cantidad de procesadores
cpu=2

# Tamaño de disco
disco=30G

# Cantidad de memoria RAM
memoria=4G

clear
date

echo "Creando máquina virtual '$nombremv' con:
- Procesadores: $cpu
- Tamaño de disco: $disco
- Memoria RAM: $memoria
..."
multipass launch -n $nombremv -c $cpu -d $disco -m $memoria 22.04
multipass mount $HOME $nombremv:Home
multipass set client.primary-name=$nombremv
multipass info $nombremv

echo "Máquina virtual creada. Preparando para su uso..."
multipass exec -n $nombremv -- sudo apt update
multipass exec -n $nombremv -- sudo apt -y upgrade
multipass restart $nombremv

date

multipass exec -n $nombremv -- sudo apt install -y avahi-daemon winbind language-pack-es manpages-es

multipass exec -n $nombremv -- sudo update-locale LANG=es_AR.UTF-8
